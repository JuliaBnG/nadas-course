# Annotations for the main program

There are too many functions in this file.  When you write the
project, it is better to separate them in different files.  They are
put together here for the convenience of copy and interpretations.

## Function `tstFlf`

- line 205-230

We go to the last function first.  This is the driver of the full
simulation.  The lines are self-stated. We

1. generate the genotype, linkage map and pedigree `DataFrame` of
   generation 0
2. define traits and genetic VCV matrix
3. define scenarios
4. make and copy of generation 0 and do the test breeding program

## Function `founder_genotype`

- line 1-38

The function generates a historical population with $N_e = 200$ and
2000 generations. At last ~ 120k segregating SNP on 26 autosomes are
obtained.

- Line 23
  - Convert the genotypes into a BitArray and a linkage map
- Line 31-35
  - sample 150 ID, 20k chip SNP, and 5k QTL
  
### Remarks

- In reality, you might increase ne and ng to create a large
  population with very many SNP to sample from.
- More complicate stuctures of historical populations may also
  generated, e.g., split, expand, and merge.
- **A 100 nok award** is earmarked to anyone who inform me first of a
  faster forward simulator than `fisher_wright` here.  The above is a
  fair setup to compare mine and others.

## Functions `trait`

line 40-54

Setup the trait infomation and genetic VCV.

## Function `pedigree`, `founder_pedigree`

These functions are self explanary.

## Function `parents`

This function selects parents according to our criteria.  Different
breeding programs require a parent function to create parent pairs
according to their own schemes.

## Function `breeding_program`

The breeding program function.  Here it select the population for 5
consective years.

### Remark

Note the `Ainv` function here is also significant.  It is faster than
most similar functions in most scenarios.  It can also deal with huge
pedigree which other program can't handle at all.

## Function `report`

Summarize the pedigree.
