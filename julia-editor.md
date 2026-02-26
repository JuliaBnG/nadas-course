# Julia Editor

You can set the default editor for Julia in your terminal using the 
following command:

```bash
export JULIA_EDITOR="code"
```

Then, start the Julia REPL:

```julia
julia> @edit sin(1)
```

This will open the source code of the `sin` function in your editor 
(e.g., VS Code).

When running Julia on a remote server, it is better to use a terminal-based 
editor such as `emacsclient -nw`, `emacsclient -t`, `vim`, or `nano`. This 
will display the highlighted source code within your terminal session.

To make this setting persistent, add the `export` command to your shell 
configuration file (e.g., `~/.bashrc` or `~/.zshrc`).
