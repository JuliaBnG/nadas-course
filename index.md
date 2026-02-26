# Learning Julia the Hard Way

> This course is primarily designed for data scientists working in
> breeding and genetics. Others who want to use Julia for different
> purposes may also find it useful. We will explore the development
> cycle of a Julia project.

## Preface

One can lift heavy weights as if they are light (in Chinese, 举重若轻),
to demonstrate capability. One can also lift light weights as if they 
were heavy (in Chinese, 举轻若重). The latter is sometimes
more meaningful, because:

- Readers here likely have some prior programming training.
- We are dealing with relatively *heavy* tasks.
- The *hard* way shown here may make life easier for readers in the future.

### What you will learn

The main goal of this course is to guide you through setting up **a Julia
simulation project**, using packages from the `JuliaBnG` ecosystem.

I will also show you how to:

- [*Optional*] Configure `git` for project version control.
- Write, manage, and build a `julia` project.
- Trace and test your `julia` project using `Revise.jl`.

Note that these configurations may not be optimal. Feedback and suggestions are welcome.

The primary objective of this tutorial is to ensure you can run the simulation package on your own computer.

### Conventions

- External links will open in a new tab.
- Annotations will appear in the rightmost column when clicked.
- Inline code is highlighted in `deep pink`.

Please feel free to click the links, especially the annotations.

### Materials

- [JuliaBnG](https://github.com/JuliaBnG)
- [Fluffy sheep breeder](https://sheep-breeder-2.vercel.app/)
- ["Source code" of this
  instruction](https://github.com/JuliaBnG/nadas-course)
- The compiled instructions you are currently reading.

## Introduction

### The task

The project we are addressing today is the design of a breeding
program for the [Fluffy sheep
breeder](https://sheep-breeder-2.vercel.app/). The breeding task is
straightforward: you can select any number of parents and assign 
arbitrary weights to the two traits. Breeding will likely continue, 
but careful planning is required to rank among the top shepherds.

### Setting up the environment

We will run simulations to test our breeding programs. This requires 
writing some scripts and tools in Julia.

Julia should already be installed on your laptop, but we will double-check 
to ensure the environment is ready for intensive tasks.

#### 1. Git

It is recommended to have `git` [installed](annotation:git-installation)
and [configured](annotation:git-configuration).

#### 2. Terminal

We will test and run the project in a terminal. Linux and macOS users
can use the built-in terminal. Windows users can use `Windows
Terminal` and WSL2, if possible. Your terminal should be able to execute the `julia` and `git` commands.

#### 3. Julia

Once your terminal is ready, regardless of your operating system, 
refer to [Julia installation](annotation:julia-installation) to 
ensure `julia` is correctly installed.

#### 4. Julia editor

The *Julia editor* mentioned here is not the one you use to write 
code. It is the editor invoked by the `@edit` macro in the Julia REPL. 
Click [here](annotation:julia-editor) to learn how to inspect the 
implementation of functions.

#### 5. Working directory

It is good practice to save your projects in a dedicated working directory, 
e.g., `~/projects`. For example, our project, named `flfSheep`, 
will be saved in `~/projects/flfSheep`.

## The project

### Best practices

Let's discuss how a simulation is conducted. [Stabilizing
Selection
Out-of-Africa](https://sashagusev.github.io/Stabilizing-Selection-Sim/)
provides an example that many programmers dream of:

- A web interface
- Parameters adjustable via GUI
- A button to start the simulation
- A progress indicator
- Results displayed in sophisticated plots

Sounds good? Let's reconsider.

A typical breeding simulation may consist of the following steps:

1. Generate a historical population to create linkage disequilibrium
   (LD).
2. Create a bottleneck to mimic the founder effect.
3. Selection over several generations.
4. Selection with updated breeding schemes, e.g., switching EBV from 
   PBLUP to GBLUP.

One might think these steps could be standardized so that parameters 
are listed in a GUI. However, what if we change the nuclear population
structure—for example, from a single large population to one 
consisting of many small flocks? What if we change the mating rules? 
Such scenarios are numerous.

Breeding practices vary by species, and practices for the same 
species may vary by country. The art of breeding, which changes 
across locations and time, makes script-based simulation more 
realistic. While established simulation procedures can be 
sophisticated, changing the simulation logic or methods can be difficult.

> To be or not to be, that is the question.

This famous line is just one of many. Organizing these lines 
results in scripts of various genres and styles. A script is more 
versatile and powerful than a GUI.

### Project analysis

We can take some figures from the [Fluffy sheep
breeder](https://sheep-breeder-2.vercel.app/) webpage:

- $N_{\mathrm{ram}} = 50$
- $N_{\mathrm{ewe}} = 100$
- Two traits
  - Curliness
    - $\mu_0 = 100$
    - $\sigma_P = 10$
  - Wool length
    - $\mu_0 = 100$
    - $\sigma_P = 10$
- The final score appears to be the mean of the two traits minus 200.

It is likely that wool length has higher heritability than
curliness.

These are my observations; please let me know if you observe different values.

Our goal is to develop a Julia simulation package to identify a 
breeding program that achieves the highest possible score.

### Development of the package

Before we start, ensure your environment is set up as described 
in the previous section. We will work within the Julia REPL until the 
project is complete.

#### 1. Create the project

In your terminal, navigate to the directory where you want to create 
the project:

```bash
cd ~/projects  # or your preferred project directory
julia          # to enter the Julia REPL
```

Press `]` to enter package mode, and execute the following commands:

```julia
generate flfSheep

# Press <backspace> to exit package mode and return to the REPL
cd("flfSheep")  # Enter the project directory

# Press `]` to enter package mode again
activate .  # Activate the project we just created

# "(flfSheep) pkg>" will be displayed as the prompt
# Type `status` to view the project's status

# Press `<backspace>` to exit package mode
using flfSheep  # Load the project
```

Click the following link to view the [project structure](annotation:project-structure).

You will see a `greet` function in the `src/flfSheep.jl` file. 
Below is an example of what you might see in your terminal:

![](start.png)

In the meantime, you may want to read about the [almighty tab](annotation:almighty-tab).

At this stage, you can use your favorite editor to modify the files 
in the project directory.

#### 2. Add `JuliaBnG` packages

In the REPL, press `]` to enter package mode, and run the following command:

```julia
add BnGStructs           # from JuliaBnG
add DataFrames
add FisherWright         # from JuliaBnG
add Random
add RelationshipMatrices # from JuliaBnG
add StatsBase

# Breeding.jl is not yet in the General registry.
# Add it using its URL:
add https://github.com/JuliaBnG/Breeding.jl  # from JuliaBnG
```

Click the next link to see [what has changed](annotation:what-have-changed).

#### 3. Write a test function

Refer to the [hello world project](annotation:hello-world-project) for 
detailed explanations and to ensure you have followed these steps correctly.

Create a file named `src/tstBreeding.jl` with the following content:

```julia
"""
  tstFlf()

Test script to identify an effective breeding program for the fluffy sheep.
"""
function tstFlf()
   @info "Starting the test function" 
end
```

In `src/flfSheep.jl`, replace the line:

```julia
greet() = print("Hello World!")
```

with:

```julia
using BnGStructs
using Breeding
using DataFrames
using FisherWright
using Random
using RelationshipMatrices
using StatsBase

include("tstBreeding.jl")

export tstFlf
```

At this point, although `flfSheep` doesn't yet perform complex 
tasks, you have successfully created a package and added its 
dependencies. This is your "Hello World" package. From here, 
you can begin developing your own breeding simulations—perhaps 
the "Hamlet" or "Macbeth" of breeding programs.

The rest of the tutorial is contained within the `tstBreeding.jl` 
file, as shown in the next section.

## The simulation

I have provided a [sample simulation
program](https://github.com/JuliaBnG/nadas-course/blob/main/tstBreeding.jl)
here with [explanations](annotation:simulation-annots). You can 
replace the contents of `src/tstBreeding.jl` in your project with 
this sample and modify it as needed.

```julia line-numbers
"""
    founder_genotype(nid)

Generate genotypes and a linkage map for `nid` sheep.
"""
function founder_genotype(nid)
    @info "Return genotypes and a pedigree"

    # Generate a historical population using the `FisherWright` package
    ne = nid + 50   # Effective population size
    ng = 2000       # Number of generations of random mating
    mr = 1.0        # Mutation rate per Morgan per meiosis
    sheep = Sheep(ne) # A Sheep struct that defines name, population size, chromosomes, and M

    mts, cbp = fisher_wright(
        ne,  # This function generates LD among SNPs
        ng,  # at mutation-drift equilibrium
        sheep.chromosome, # Chromosome lengths downloaded from NCBI
        mr;
        M = sheep.M,  # 10⁸ bp per Morgan
    )

    hxy, lmp = muts2bitarray(mts, cbp; flip = true)

    # Sample an exclusive 20k SNP chip and 5k QTL. Sample 150 IDs.
    # - First, sample 150 IDs
    maf = 0.0
    hxy, lmp = sampleID(hxy, lmp, maf, nid)

    # - Sample chip SNPs and QTLs
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
    V = [ # Genetic VCV matrix for these two traits
        64.0 -30
        -30 36  # r = -5/8; adjust -30 for a different correlation.
    ]
    return trts, V
end

"""
    pedigree(prt, trts)

Create an empty pedigree to be updated later.
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
    
Create the pedigree for the founder generation (G0) using genotypes 
and the linkage map. QTL effects are sampled based on the genetic 
VCV matrix `V`, and TBV and phenotypes are calculated.
"""
function founder_pedigree(hxy, lmp, nram, trts, V)
    eqtl(hxy, lmp, V, trts)  # Sample QTL effects for the two traits.
    nid = size(hxy, 2) ÷ 2
    ped = pedigree(zeros(Int32, nid, 2), trts, nram)
    tbv!(ped, hxy, lmp, trts)
    phenotype!(ped, trts)
    return ped
end

"""
    parents(ped, nram, newe)

Select parents from the most recent generation of the pedigree to 
breed the next generation. Sires and dams are selected based on 
their Total Merit Index (TMI) in descending order.

Different breeding schemes can use alternative selection strategies 
by implementing a new `parents` function.
"""
function parents(ped, nram, newe)
    # Filter the pedigree for the most recent generation
    tpd = filter(row -> row.generation == ped.generation[end], ped)
    # Select rams and ewes separately 
    spd = groupby(tpd, :sex)

    cnd = spd[(sex = 1,)]
    idx = sortperm(cnd.tmi, rev=true)[1:nram]
    rams = cnd.id[idx]

    cnd = spd[(sex = 0,)]
    idx = sortperm(cnd.tmi, rev=true)[1:newe]
    ewes = cnd.id[idx]

    nid = size(tpd, 1)

    # Produce the same number of offspring as the previous generation
    sires = StatsBase.sample(rams, nid; replace = true)
    dams = StatsBase.sample(ewes, nid; replace = true)
    sortslices([sires dams], dims = 1)
end

"""
    breeding_program(hxy, lmp, ped, lms, trts, V, nram, scenario; ngen = 5)

Run a breeding program to update the pedigree and select parents for 
future generations. Multi-trait BLUP is used to update EBVs, 
and TMI is calculated accordingly.
"""
function breeding_program(hxy, lmp, ped, lms, trts, V, nram, scenario; ngen = 5)
    for gen in 1:ngen
        @info "Generation $gen"

        # Inverse of the numerator relationship matrix
        Ai = Ainv(ped)

        # Update EBV using multi-trait BLUP
        mtpblup(ped, trts, Ai, V)

        # Update TMI
        ped.tmi = scenario.w * ped.ebv_cn + (1 - scenario.w) * ped.ebv_wl

        # Select parents based on TMI
        prt = parents(ped, scenario.nram, scenario.newe)

        # Placeholder for offspring genotypes
        off = falses(size(hxy, 1), size(prt, 1) * 2)

        # Simulate genotypes for offspring
        gene_drop(hxy, off, prt, lms, lmp.pos)

        # Temporary pedigree for the next generation
        tpd = pedigree(prt, trts, nram)

        # Calculate TBV for offspring
        tbv!(tpd, off, lmp, trts)
        
        # Calculate phenotypes for offspring
        phenotype!(tpd, trts)

        # Update generation number for offspring
        tpd.generation .= gen

        # Update ID for offspring
        tpd.id .+= ped.id[end]

        # Update pedigree with offspring
        append!(ped, tpd)

        # Update genotypes with offspring
        hxy = hcat(hxy, off) 
    end

    return ped
end

"""
    report(ped)

Report the average score and inbreeding coefficient for the final 
generation of the pedigree.
"""
function report(ped)
    @info "Final score and inbreeding coefficient for the last generation:"
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

Test program to identify an optimal breeding scheme for Fluffy sheep. 
This function can use brute-force loops to find a plan that 
maximizes the score on https://sheep-breeder-2.vercel.app/.
"""
function tstFlf()
    @info "Starting test..."

    @info "  - Generating genotypes, linkage map, traits, and G0 pedigree"
    nram, newe = 50, 100
    hxy, lmp, lms = founder_genotype(nram + newe)

    trts, V = traits()
    ped = founder_pedigree(hxy, lmp, nram, trts, V)

    scenario = (nram = 25, newe = 50, w = 0.5)

    # Maintain a copy of original data for testing different scenarios
    cxy, cmp, cpd = copy(hxy), copy(lmp), copy(ped)

    @info "Scenario: " scenario
    tpd = breeding_program(cxy, cmp, cpd, lms, trts, V, nram, scenario)
    report(tpd)
end
```

This simulation is lightning fast. I have provided the basic framework; 
to tackle the problem set introduced at the beginning, you might 
loop through various scenarios (e.g., varying `nram` from 10 to 40) 
to find the optimal result.

## Final remarks

I hope you enjoyed this tutorial. Below are a few additional topics 
I would like to address.

### AI in Development

The template for this tutorial was generated with AI assistance. 
Starting from a single prompt for a two-column webpage, I refined it 
through several iterations to reach this final format. You can 
download the complete "source code" for this tutorial from the 
`JuliaBnG` [GitHub page](https://github.com/JuliaBnG/nadas-course). 
For example:

```bash
git clone https://github.com/JuliaBnG/nadas-course
```

AI tools are becoming indispensable for modern workflows. My 
arguments for using AI are:

First:
> The AI tools that have significantly impacted the computer science 
> workforce must be effective to some degree. They are also easily 
> accessible.

Second:
> AI acts as a multiplier. Its effectiveness depends on the user's 
> knowledge. The more you know, the more effectively you can prompt 
> and utilize AI.

Third:
> AI excels at generating and explaining command-line operations and 
> scripts. It is good practice to become familiar with these tools.

Furthermore:
> Markdown is becoming a universal "programming language" for documentation. 
> Julia offers the unique advantage of being as easy to write as 
> Python while delivering the performance of C or Fortran.

### Simulation packages

Not all of my simulation code will be open-sourced. The primary reason 
is that organizing and maintaining these packages requires 
substantial resources and funding.

---

*This tutorial was written in February 2026.*

by *Dr. Xijiang Yu*

*Last updated: February 26, 2026*
