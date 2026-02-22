# Git Configuration

## Configuration

The easiest way to configure `git` is to save the following configuration in the `~/.gitconfig` file.

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

- modify name, user and email to your own
- core editor can be code if you are using `git` locally. Otherwise, it is
  better to use `nano`, `emacs` or `vim`. The `emacsclient -ct` here is using
  `emacs` user service.
- if you manage Jupyter notebook versions, the last group may be very useful.

## Bash

You can run the following commands to configure `git`. Remember to modify the
name, user and email to your own.

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
