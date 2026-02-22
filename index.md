# Learning easy Julia the hard way

*This course is primarily designed for data scientists working on breeding and
genetics.  People who want to use Julia for other purposes may also find it
useful.*

## Preface

One can lift heavy weights as if they are light (in Chinese, 举重若轻), to show
its capability.  One can also lift light weights the way to lift heavy weights
(in Chinese, 举轻若重).  The latter is sometime more meaningful:

- The readers here have most probably had some programming trainings before.
- We are dealing with *heavier* tasks more or less.
- The *hard* way shown here may serve the readers a easier life in the future.

### What you will learn in this course

The main goal of this course is to instruct you to set up a Julia simulation
project, which uses packages that are under the umbrella of `JuliaBnG`.

We will show you how to

- [*Optional*] Configure `git` to manage your project.
- Write, manage and build a `julia` project.
- Trace and test your `julia` project using `Revise.jl`.

## Introduction

### The task

The project we are going to deal with today is to design a breeding program to
tackle [Fluffy sheep breeder](https://sheep-breeder-2.vercel.app/). The task is
easy to carry out, as you can select arbitrary number of parents and arbitrary
weights on the two traits. The breeding will very likely go on.  You might need
to think more carefully to have your name appear in the top shepherds.

### Setting up the environment

We are going to run some simulation to test our breeding programs. We will do
some scripting and tools written in Julia.  We have already had Julia installed
on our laptops.  But we are still going through again to see if our environment
is ready for heavy lifting.

#### 1. Git

You'd better to have `git` [installed](annotation:git-installation) and
[configured](annotation:git-configuration).

#### 2. Terminal

You will test and run the project in a terminal.  Linux and MacOS users can use
the built-in terminal.  Windows users can use `Windows Terminal` and WSL2.  You
will setup your terminal that can run command `julia` and `git`. 

#### 3. Julia

Once you have your terminal ready, whether you are using Linux, MacOS or
Windows, go through [Julia installation](annotation:julia-installation) to make
sure if you `julia` is properly installed.

#### 4. Julia editor

*Julia editor* here doesn't refer to the editor you write your codes.  It is the
one when you run `julia` macro `@edit` invoked in the REPL.  Click
[here](annotation:julia-editor) to see if you want to know how a function you
are using is implemented.

#### 5. Working directory

It is a good habit to save your project in a working directory, e.g.,
`~/projects`.  Our project, which we can name it as `flfSheep`, will be
saved in `~/projects/flfSheep`.

## The project

### The best practices

Let's talk about how a simulation is carried out.  [Stabilizing Selection
Out-of-Africa](https://sashagusev.github.io/Stabilizing-Selection-Sim/) shows an
example that many programmers once dreamed of:

- A web interface
- Once sets up parameters with GUI
- Click a button to start the simulation
- Wait for the simulation to finish
- Get the results in a fancy plot

Sound nice?  Let think this twice.

A typical simulation of breeding practice may consist of the following steps:

1. Generate a historical population to create linkage disequilibrium (LD).
2. Generate a bottleneck to mimic the founder effect.
3. Selection a few generations.
4. Selection with changed breeding schemes, e.g., with EBV from PBLUP to GBLUP.

One may think that the above steps can be standardized, such that we can list
the parameters in a GUI, and click a button to start the simulation.  However,
what if change the nuclear population structure, e.g., from a single large
population to a one that consists many small flocks?  What if we change the
mating rules? 

The breeding practices of different species are different.  The practice of a
same species raised in different countries may also differ.  The art of breeding
that varies from place to place and from time to time makes script-based
simulation more appealing.

> To be or not to be, that is a question.

is a famous line.  Organization of many of such lines makes many scripts of
different genres and styles.  In other words, one doesn't write a script using
the same template.

### Project analysis

We can take some key figures from the [Fluffy sheep breeder](https://sheep-breeder-2.vercel.app/):

- $N_{\mathrm{ram}} = 50$
  - determined by dragging the slider to the right most.
- $N_{\mathrm{ewe}} = 100$
- Two traits
  - Curliness
  - Wool length

Let's observe more about the two traits.  From the Flock Average plot, we can
see the means of the two traits are both 100 at generation 0.  From the the
scatter plot of flock candidates, we can see that the two traits are both ranged
in about (70, 130).  We can guess that $\sigma_P$ of both traits are about 10.

The two traits are negatively correlated.  The phenotype plot shows that the
regression coefficient is about -1.  If we select 20 rams and 60 ewes in
generation 0, and balanced weights to produce generation 1, curliness usually
has more progress than wool length.  Curliness here seems to have higher
heritability than wool length as if we weight curliness more, there are more
last generation genetic trend difference than that of weighting wool length
more.

Another parameter is inbreeding. The site want it to be less than 1.25%.  This
can be determined easily.  We can come back to this later.

To make a high score, we need to know how is the final score calculated.  

To summarize, we know the following:

- $N_{\mathrm{ram}} = 50$
- $N_{\mathrm{ewe}} = 100$
- $\sigma_{P,1} \approx 10$
- $\sigma_{P,2} \approx 10$
- $\rho_{P,12} \approx -1$
- $\Delta F < 1.25\%$
- 
We want to know:

- How is the final score calculated?
