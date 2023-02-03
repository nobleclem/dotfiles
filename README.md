dotfiles
========
My server environment dotfiles with autoupdate functionality upon server login.

## Setup
```
cd ~
git clone ssh://git@github.com/nobleclem/dotfiles.git
mv .profile .profile-bak
ln -s dotfiles/profile .profile
source .profile
```

## Omit Repo Dotfile
Create/Edit .profile.local and add following.  This example excludes the .gitconfig from being used.  Replace `gitconfig` with dotfile of choice.
```
# remove gitconfig
dotfiles=${dotfiles/gitconfig/}
dotfiles=${dotfiles/  / }
```
