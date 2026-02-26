# A Hello World Project

The contents of the `src/flfSheep.jl` file:

```julia
module flfSheep

using BnGStructs
using Breeding
using FisherWright
using RelationshipMatrices

include("tstBreeding.jl")
# More files can be included here. 
# Pay attention to the order of function definitions if using Julia 1.12 or later.

export tstFlf # Expose the function

end # module flfSheep
```

The contents of the `src/tstBreeding.jl` file:

```julia
"""
    tstFlf()

A test program to identify an effective breeding scheme for Fluffy sheep.
"""
function tstFlf()
    @info "Starting test..."
end
```

The text within the triple quotes constitutes the docstring for the 
`tstFlf` function.

In your REPL:

```julia
flfSheep.tstFlf()
# or, if you have "export tstFlf" in flfSheep.jl:
tstFlf()
```

This will display the information from the `tstFlf` function. The 
REPL recognizes the function because of the `Revise.jl` package we 
activated earlier. It is a highly recommended tool.

In your REPL:

```julia
?tstFlf # Type '?' to enter help mode
```

This will display the function's docstring. This is particularly 
useful as your collection of functions grows, and these docstrings 
can also be automatically incorporated into your manual later.
