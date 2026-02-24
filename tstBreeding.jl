"""
    founder_genotype(nid)

Generate genotypes and their linkage map for `nid` sheep.
"""
function founder_genotype(nid)
    @info "Return genotypes and a pedigree"

    # Generate a historic population using package `FisherWright`
    ne = nid + 50   # effective population size
    ng = 2000  # number of generations of random mating of `ne` ID
    mr = 1.0   # mutation rate per Morgan per meiosis
    sheep = Sheep(ne) # A Sheep Struct that define its name, pop size, chrs, and M

    mts, cbp = fisher_wright(
        ne,  # this function generate LD among SNPs
        ng,  # at mutation-drift equilibrium
        sheep.chromosome, # lengths in bp downloaded from NCBI
        mr;
        M = sheep.M,  # 10⁸ bp per Morgan
    )

    hxy, lmp = muts2bitarray(mts, cbp; flip = true)

    # Sample exclusive 20k chip SNP and 5k QTL. Sample 150 ID
    # - we sample 150 ID first
    maf = 0.0
    hxy, lmp = sampleID(hxy, lmp, maf, nid)

    # - sample chip SNP and QTL
    nchp, nqtl = 20_000, 5_000
    chip = SNPSet("chip", nchp; maf = 0.1, exclusive = true)
    qtl = SNPSet("qtl", nqtl; maf = 0.0, exclusive = true)
    hxy, lmp = sampleLoci(hxy, lmp, chip, qtl)
    lms = sum_map(sheep.chromosome)

    return hxy, lmp, lms
end

"""
    traits()

Define the traits of interest and their genetic VCV matrix.
"""
function traits()
    curliness = Trait("cn"; h² = 0.64, μ = 100.0, σₐ = 8)
    wlength = Trait("wl"; h² = 0.36, μ = 100.0, σₐ = 6)
    trts = [curliness, wlength]
    V = [ # genetic VCV matrix of these two traits
        64.0 -30
        -30 36  # r = -5/8, modify -30 if you want other r.
    ]
    return trts, V
end

"""
    pedigree(prt, trts)

Create an empty pedigree whose values are to be updated later.
"""
function pedigree(prt, trts, nram)
    nid = size(prt, 1)
    newe = nid - nram
    ped = DataFrame(
        id = Int32.(1:nid),
        sire = prt[:, 1],
        dam = prt[:, 2],
        generation = Int8.(0),
        sex = shuffle([zeros(Int8, newe); ones(Int8, nram)]),
        tmi = 0.0,
    )
    
    for pre in ("tbv_", "ft_", "ebv_")
        for t in trts
            ped[!, pre * t.name] .= 0.0
        end
    end
    ped
end

"""
    founder_pedigree(hxy, lmp, nram, trts, V)
    
Create the pedigree for generation 0 (the founder generation) with the
genotypes and the linkage map.  The QTL effects are sampled based on
the genetic VCV matrix `V` of the traits, and the TBV and phenotypes
are calculated based on the genotypes and the QTL effects.
"""
function founder_pedigree(hxy, lmp, nram, trts, V)
    eqtl(hxy, lmp, V, trts)  # sample the QTL effects for the two traits.
    nid = size(hxy, 2) ÷ 2
    ped = pedigree(zeros(Int32, nid, 2), trts, nram)
    tbv!(ped, hxy, lmp, trts)
    phenotype!(ped, trts)
    return ped
end

"""
    parents(ped, nram, newe)

Select parents from the last generation of the pedigree `ped` to breed
the next generation.  The sires and dams are selected based on their
TMI (total merit index) values from high to low.

Different breeding schemes can have different parents selection
strategies.  A new `parents` function can be implemented and plugged
in here.
"""
function parents(ped, nram, newe)
    # find the last generation of the pedigree 
    tpd = filter(row -> row.generation == ped.generation[end], ped)
    # select rams and ewes separately 
    spd = groupby(tpd, :sex)

    cnd = spd[(sex = 1,)]
    idx = sortperm(cnd.tmi, rev=true)[1:nram]
    rams = cnd.id[idx]

    cnd = spd[(sex = 0,)]
    idx = sortperm(cnd.tmi, rev=true)[1:newe]
    ewes = cnd.id[idx]

    nid = size(tpd, 1)

    # produce the same number of offspring as the last generation
    sires = StatsBase.sample(rams, nid; replace = true)
    dams = StatsBase.sample(ewes, nid; replace = true)
    sortslices([sires dams], dims = 1)
end

"""
    breeding_program(hxy, lmp, ped, lms, trts, V, nram, scenario; ngen = 5)

A breeding program to update the pedigree and select parents for the
next generation.  In this function, multiple trait BLUP is used to
update the EBV of the two traits, and the TMI is updated based on the
EBV.  The parents are selected based on the TMI values.
"""
function breeding_program(hxy, lmp, ped, lms, trts, V, nram, scenario; ngen = 5)
    for gen in 1:ngen
        @info "Generation $gen"

        # Inverse of the numerator relationship matrix
        Ai = Ainv(ped)

        # update EBV using multiple trait BLUP
        mtpblup(ped, trts, Ai, V)

        # update TMI
        ped.tmi = scenario.w * ped.ebv_cn + (1 - scenario.w) * ped.ebv_wl

        # select parents based on TMI
        prt = parents(ped, scenario.nram, scenario.newe)

        # placeholder for offspring genotypes
        off = falses(size(hxy, 1), size(prt, 1) * 2)

        # simulate genotypes for offspring
        gene_drop(hxy, off, prt, lms, lmp.pos)

        # temporary pedigree for the next generation
        tpd = pedigree(prt, trts, nram)

        # calculate TBV for offspring
        tbv!(tpd, off, lmp, trts)
        
        # calculate phenotypes for offspring
        phenotype!(tpd, trts)

        # update generation number for offspring
        tpd.generation .= gen

        # update ID for offspring
        tpd.id .+= ped.id[end]

        # update pedigree with offspring
        append!(ped, tpd)

        # update genotypes with offspring
        hxy = hcat(hxy, off) 
    end

    return ped
end

"""
    report(ped, Ai)
Report the average score and inbreeding coefficient of the last
generation in the pedigree `ped` based on the numerator relationship
matrix `Ai`.
"""
function report(ped)
    @info "The final score and inbreeding coefficient of the last generation"
    lg = groupby(ped, :generation)[(generation = ped.generation[end],)]
    @info "  - Score: ", round(mean(lg.tbv_cn) + mean(lg.tbv_wl), digits = 2)
    ic = 0.0
    A = nrm(ped)
    for id in lg.id
        ic += A[id, id] - 1
    end
    ic /= size(lg, 1)
    @info "  - Inbreeding coefficient: ", round(ic, digits = 3)
end

"""
    tstFlf()

Tests program to find a good breeding scheme for Fluffy sheep.  In
this function, brute force loops can be used to find a breeding plan
to reach high score on https://sheep-breeder-2.vercel.app/.
"""
function tstFlf()
    @info "Start testing..."

    @info "  - Generate genotypes, linkage map, traits, and pedigree for generation 0"
    nram, newe = 50, 100
    hxy, lmp, lms = founder_genotype(nram + newe)

    trts, V = traits()
    ped = founder_pedigree(hxy, lmp, nram, trts, V)

    scenario = (nram = 25, newe = 50, w = 0.5)

    # keep a copy of the original data for testing different scenarios
    cxy, cmp, cpd = copy(hxy), copy(lmp), copy(ped)

    @info "Scenario: " scenario
    tpd = breeding_program(cxy, cmp, cpd, lms, trts, V, nram, scenario)
    report(tpd)
end
