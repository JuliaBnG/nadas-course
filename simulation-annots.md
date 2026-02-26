# Annotations for the Main Program

This file contains a large number of functions. In a production project, 
it is better to organize them into separate files. They are consolidated 
here for easier reference and explanation.

## Function `tstFlf`

- lines 205-230

Let's examine the last function first; it serves as the main driver 
for the full simulation. The code is largely self-explanatory:

1. Generate the genotypes, linkage map, and pedigree `DataFrame` 
   for generation 0.
2. Define the traits and the genetic VCV matrix.
3. Define the simulation scenarios.
4. Create a copy of generation 0 and execute the test breeding program.

## Function `founder_genotype`

- lines 1-38

This function generates a historical population with $N_e = 200$ over 
2,000 generations. Approximately 120,000 segregating SNPs across 26 
autosomes are obtained.

- **Line 23**: Convert genotypes into a `BitArray` and a linkage map.
- **Lines 31-35**: Sample 150 IDs, a 20k SNP chip, and 5k QTLs.
  
### Remarks

- In practice, you might increase `ne` and `ng` to create a larger 
  population with more SNPs to sample from.
- More complex historical population structures, such as splits, 
  expansions, and merges, can also be generated.
- **A 100 NOK award** is offered to the first person to identify a 
  forward simulator faster than `fisher_wright` under these conditions. 
  The setup above provides a fair basis for comparison.

## Function `traits`

- lines 40-54

Configure trait information and the genetic VCV matrix.

## Functions `pedigree` and `founder_pedigree`

These functions are self-explanatory.

## Function `parents`

This function selects parents based on specified criteria. Different 
breeding programs can implement their own parent selection logic to 
create pairs according to their specific schemes.

## Function `breeding_program`

The main breeding program function. In this example, it simulates 
selection over five consecutive generations.

### Remark

The `Ainv` function is particularly noteworthy: it is exceptionally 
fast and capable of handling massive pedigrees that often cause other 
programs to fail.

## Function `report`

Generates a summary of the pedigree data.
