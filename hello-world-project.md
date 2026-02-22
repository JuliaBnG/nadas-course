# A Hello World Project

The contents of file `src/flfSheep.jl`.

```julia
module flfSheep

using BnGStructs
using Breeding
using FisherWright
using RelationshipMatrices

include("tstBreeding.jl")
# more files can be included here. 
# pay attention to the order of function definition if using julia 1.12+.

export tstFlf # to expose the function

end # module flfSheep
```

The contents of file `src/tstBreeding.jl`.

```julia
"""
    tstFlf()
Tests program to find a good breeding scheme for Fluffy sheep.
"""
function tstFlf()
    @info "Start testing..."
end
```

The strings between the two triple quotes are the docstrings of
function `tstFlf`.

In your REPL:

```julia
flfSheep.tstFlf()
# or, if you have "export tstFlf" in flfsheep.jl
tstFlf()
```

Will show the info from function `tstFlf`.  The reason that your REPL
can recognize the function is because of the package `Revize.jl` we
added in the beginning.  It is a must-have.

In your REPL

```julia
?tstFlf # type '?' to enter the help mode
```

will show you the docstring of the function.  These will be very
useful if you have written a lot of functions.  These docstrings can
also serve as contents of your manual automatically later.
