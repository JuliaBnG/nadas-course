# Julia Installation

The recommended way to install Julia is to run the following command in 
your terminal:

```bash
curl -fsSL https://install.julialang.org | sh
```

This will install the latest stable version of Julia, as well as the 
`juliaup` tool. Start Julia from the command-line by typing `julia`. 
This will launch the Julia REPL (Read-Eval-Print Loop). You should see 
something similar to this:

![](repl.png)

Press `]` to enter package manager mode:

```julia
add Revise
```

Then press `Ctrl-D` to exit the Julia REPL.

Create (or modify) a file at `~/.julia/config/startup.jl` with the 
following content:

```julia
using Revise
```

Subsequently, `Revise` will be loaded automatically whenever you 
start Julia.

`Revise` is an essential tool for Julia development. It allows you to 
modify your code and observe the changes immediately without needing 
to restart the session. We will use it throughout this course.
