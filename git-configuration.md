# Git Configuration

## Configuration

The most direct way to configure `git` is to save the following content into your `~/.gitconfig` file.

```toml
[user]
	name = Xijiang Yu
	email = xijiang@users.noreply.github.com
[github]
	user = xijiang
[core]
	editor = emacsclient -ct
[alias]
	ss = status -s
	lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches
	tg = log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d'
[init]
	defaultBranch = main
[credential]
	helper = cache
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
[filter "remove-notebook-output"]
	clean = "jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR"
```

## Notes

- **Replace** the name, user, and email with your own details.
- The **core editor** can be set to `code` if you are using `git` locally. Otherwise, using `nano`, `emacs`, or `vim` is recommended. The `emacsclient -ct` setting shown here utilizes the `emacs` user service.
- If you manage **Jupyter notebook versions**, the final configuration group will be very useful.

## Using the Command Line

Alternatively, you can use the following commands to configure `git`. Remember to substitute your own details for the placeholders.

```bash
git config --global user.name "Xijiang Yu"
git config --global user.email "xijiang@users.noreply.github.com"
git config --global github.user "xijiang"
git config --global core.editor "emacsclient -ct"
git config --global alias.ss "status -s"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"
git config --global alias.tg "log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d'"
git config --global init.defaultBranch "main"
git config --global credential.helper "cache"
git config --global filter.lfs.clean "git-lfs clean -- %f"
git config --global filter.lfs.smudge "git-lfs smudge -- %f"
git config --global filter.lfs.process "git-lfs filter-process"
git config --global filter.lfs.required true
git config --global filter.remove-notebook-output.clean "jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR"
```
