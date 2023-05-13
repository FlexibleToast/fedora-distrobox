# fedora-distrobox

## Scope

This is an image I'm personally using with distrobox on a Fedora Silverblue installation to serve as my terminal and includes tools I use. The goal is to make my desktop experience more repeatable and more inline with IaC (Infrastructure as Code) principles. Only packages should be added here, there are better tools for managing configurations. I've started using [chezmoi](https://www.chezmoi.io/) to manager my configs.

## How to use

### Create Box

If you use distrobox:

```bash
distrobox create --image ghcr.io/flexibletoast/fedora-distrobox --name fedora
distrobox enter fedora
```

If you use toolbx:

```bash
toolbox create --image ghcr.io/flexibletoast/fedora-distrobox fedora
toolbox enter fedora
```

### Pull down your config

Use `chezmoi` to pull down your dotfiles and set up git sync. Personally I have a small `bootstrap.sh` script that gets synced with Nextcloud. That small script sets up my ssh keys and then initializes `chezmoi`.

Example:

```bash
#!/bin/bash

github_username= # Add your github username
backup_dir="$HOME/Backup"

setupSSH(){
  # if ssh keys aren't already setup or haven't been used, link them to where they're stored
  if [[ ! -f $HOME/.ssh/known_hosts ]]; then
    rm -rf $HOME/.ssh
    chmod 400 $backup_dir/ssh/*
    chmod 600 $backup_dir/ssh/{authorized_keys,config,known_hosts}
    ln -s "$backup_dir/ssh" "$HOME/.ssh"
  fi
}

installChezmoi(){
  sh -c "$(curl -fsLS get.chezmoi.io)" -- \
    -b  $HOME/.local/bin \
    init --apply git@github.com:$github_username/dotfiles.git
}

setupSSH
installChezmoi
```

### Make your own

Fork and add programs to this this image - over time you'll end up with the perfect CLI for you.
Adding programs is simple, you can add any program you want to text file in the `packages.d` directory as long as they end with `.pkgs`. If your packages need a special repository, add that repository to `repos.d` and make sure they end with `.repo`.

The user experience is much nicer if you [set your terminal open right in the container](https://distrobox.privatedns.org/useful_tips.html#using-distrobox-as-main-cli) and is the intended experience. 
