# Learning easy Julia the hard way

*This course is primarily designed for data scientists working on breeding and
genetics.  People who want to use Julia for other purposes may also find it
useful.  We will learn the development cycle of a Julia project.*

## Preface

One can lift heavy weights as if they are light (in Chinese, 举重若轻), to show
its capability.  One can also lift light weights the way to lift heavy weights
(in Chinese, 举轻若重).  The latter is sometime more meaningful:

- The readers here have most probably had some programming trainings before.
- We are dealing with *heavy* tasks more or less.
- The *hard* way shown here may serve the readers an easier life in the future.

### What you will learn

The main goal of this course is to instruct you to set up a Julia simulation
project, which uses packages that are under the umbrella of `JuliaBnG`.

We will show you how to

- [*Optional*] Configure `git` to manage your project.
- Write, manage and build a `julia` project.
- Trace and test your `julia` project using `Revise.jl`.

Note that my configurations may not be optimal.  You may give me some feedback
and suggestions at the bottom of the page.

### Conventions

- External links will be opened in a new tab if clicked.
- Annotations will appear in the right most column if clicked.
- Inline codes are in `deep pink` color.
- Feel free to click the links, especially the annotations.

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

We can take some numbers from the [Fluffy sheep breeder](https://sheep-breeder-2.vercel.app/) webpage:

- $N_{\mathrm{ram}} = 50$
- $N_{\mathrm{ewe}} = 100$
- Two traits
  - Curliness
    - $\mu_0 = 100$
    - $\sigma_P = 10$
  - Wool length
    - $\mu_0 = 100$
    - $\sigma_P = 10$
- Final score seems to be final mean of the two traits minus 200.

It is likely that the wool length has higher heritability than curliness.

Above are my observations.  Correct me if you find otherwise.  

Our task is to write a Julia simulation package to run on our own computer to
find a breeding program that can achieve the highest score possible.

### Development of the package

Before we start, make sure again that you have had your environment setup as
described in the previous section.  We will stay in the Julia REPL until we
finish the project.  

#### 1. Create the project

In your terminal, go to the directory where you want to create the project:

```bash
cd ~/projects  # or the directory you want to save your project
julia          # to enter Julia REPL
```

Type `]` to enter the package mode, and then type the following command:

```julia
generate flfSheep
# type <backspace> to exit the package mode, and back to the REPL
cd("flfSheep")  # to enter the project directory
# type `]` to enter the package mode again
activate .  # to activate the project we just created
# "(flfSheep) pkg>" is shown as the prompt
# type `status` to see the status of the project
# type `<backspace>` to exit the package mode
using flfSheep  # to load the project
```

Click the next link to see the [structure of the
project](annotation:project-structure).

We can see that there is a `greet` function in the `src/flfSheep.jl` file.
Below is what you might see in your terminal:

![](start.png)

Mean while, you might want to read the [almighty tab](annotation:almighty-tab)

At this stage, you can use your favorite editor to edit the files in the project
directory.

#### 2. Add some `JuliaBnG` packages

In the REPL, type `]` to enter the package mode, and then type the following command:

```julia
add BnGStructs
add FisherWright
add RelationshipMatrices
# I haven't registered Breeding.jl in the General registry while writing this tutorial.
# You can add it by using the following command:
add https://github.com/JuliaBnG/Breeding.jl
```

Click the next link to see [what have changed](annotation:what-have-changed).

#### 3. Write a test function

Refer [hello world project](annotation:hello-world-project) to make sure that
you have done the steps below correctly, as well as some explanations.

Create a file `src/tstBreeding.jl` with the following content:

```julia
"""
  tstFlf()

Test scripts to find a good breeding program for the fluffy sheep.
"""
function tstFlf()
   @info "Starting the test function" 
end
```

Replace the line

```julia
greet() = print("Hello World!")
```

in `src/flfSheep.jl` with 

```julia
using BnGStructs
using FisherWright
using RelationshipMatrices
using Breeding

include("tstBreeding.jl")
```

Up to now, although the package `flfSheep` doesn't do anything useful, we have
successfully created a package and added some dependencies to it.  This is a
package *Hello world*.  From this point, we can start to write our own breeding
program simulation, which might be a `Hamlet` or `Macbeth` in breeding.

The rest of the tutorial will focus on the `tstBreeding.jl` file, which are in a
new section.

## The simulation

I will post a skeleton of the simulation program here with
[explanations](annotation:simulation-skeleton).