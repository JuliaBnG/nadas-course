# Julia editor

In your terminal, you can set the default editor for Julia as follows:

```bash
export JULIA_EDITOR="code"
```

Then, start the Julia REPL.

```julia
julia> @edit sin(1)
```

You will see the codes of `sin` function in the VS Code editor.

If you are running `julia` on a remote server, it is better to change `code`
above to `emacsclient -ct`, `vim`, `nano` etc.  You will see the (high  lighted)
codes in the REPL.

To make editor persistent, you can add the `export` command above to your
`.bashrc` file.
