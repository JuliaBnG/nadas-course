# Project Structure

This will create a new directory `flfSheep` with the following structure:

```
flfSheep/
├── Project.toml
└── src/
    └── flfSheep.jl
```

The project file `Project.toml` looks something like this:

```toml
name = "flfSheep"
uuid = "..."
authors = ["Your Name <[EMAIL_ADDRESS]>"]
version = "0.1.0"
...
```

The file `src/flfSheep.jl` is the main entry point of the project.  It looks like this:

```julia
module flfSheep

greet() = print("Hello World"

end # module flfSheep
```

## What's more

In the directory `flfSheep`, you can do version control with `git` command
lines:

```bash
git init
git add Project.toml src/flfSheep.jl
git commit -m "Initial commit"
```
