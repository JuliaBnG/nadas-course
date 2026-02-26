# Project Structure

The project directory `flfSheep` will have the following initial structure:

```
flfSheep/
├── Project.toml
└── src/
    └── flfSheep.jl
```

The `Project.toml` file will contain configuration similar to this:

```toml
name = "flfSheep"
uuid = "..."
authors = ["Your Name <[EMAIL_ADDRESS]>"]
version = "0.1.0"
...
```

The `src/flfSheep.jl` file serves as the main entry point for the 
module:

```julia
module flfSheep

greet() = print("Hello World!")

end # module flfSheep
```

## Next Steps

Within the `flfSheep` directory, you can initialize version control 
using `git`:

```bash
git init
git add Project.toml src/flfSheep.jl
git commit -m "Initial commit"
```
