---
layout: post
title:  "Using multiple SSH keys for different GitHub accounts"
date:   1970-01-01 00:00:00 -0600
categories: dev
---

Consider that these are the normal steps to add a new repo to github:

```bash
echo "# anotherproject" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:anotheraccount/anotherproject.git
git push -u origin main
```

But let's assume you just created another GitHub account (`anotheraccount`) and will be using it for the first time, adding new repo `anotherproject`.

First we need to create a new SSH key and add it to `anotheraccount`. GitHub won't allow you to associate a single SSH key with multiple accounts so you will not be able to use your existing SSH key, assuming you've already added it to your existing GitHub account (`yourname`). You must create another SSH key for `anotheraccount`. But how will Git know which one to use? Keep reading to find out...

Change to the ssh directory
```bash
$ cd ~/.ssh
```

Generate a new ssh key using email associated with second github account
```bash
~/.ssh$ ssh-keygen -t ed25519 -C "anotheraccount@gmail.com"
```

When prompted, give it the name `id_ed25519_anotheraccount`. Do not use the default name (`id_ed25519`) or you'll overwrite your existing SSH key. Now you should have two public/private SSH key pairs:

```bash
~/.ssh$ ls
id_ed25519  id_ed25519_anotheraccount  id_ed25519_anotheraccount.pub  id_ed25519.pub  known_hosts
```

Add the new private key (`id_ed25519_anotheraccount`) to the SSH agent:
```bash
~/.ssh$ ssh-add id_ed25519_anotheraccount
```

Add the new public key (`id_ed25519_anotheraccount.pub`) to your new GitHub account (Settings -> SSH and GPG keys -> New SSH Key).

Modify the SSH config:

```bash
~/.ssh$ touch config
~/.ssh$ subl -a config
```

~/.ssh/config
```bash
#yourname account
Host github.com-yourname
	HostName github.com
	IdentityFile ~/.ssh/id_ed25519
	IdentitiesOnly yes

#anotheraccount
Host github.com-anotheraccount
	HostName github.com
	IdentityFile ~/.ssh/id_ed25519_anotheraccount
	IdentitiesOnly yes
```

Now the trick is to use "github.com-anotheraccount" in place of "github.com" if you need to force it to use the new SSH key.

I.e. 
```bash
$ git remote add origin git@github.com-anotheraccount:anotheraccount/anotherproject.git
```

Alternatively you can set the host in the git config file:

```bash
[remote "origin"]
        url = git@github.com-anotheraccount:anotheraccount/anotherproject.git
```

And don't forget to set your name and email when you switch accounts:

```bash
$ git config --global user.name "anotheraccount"
$ git config --global user.email "anotheraccount@gmail.com" 
```

# Misc.

###### How to display git config
```bash
$ git config --list
user.email=yourname@gmail.com
user.name=Your Name
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
```

###### How to set git settings
```bash
$ git config --global user.email yourname@gmail.com
$ git config --global user.name "Your Name"
```

###### How to unset a git setting (use case: removing a second *user.name*)
```bash
$ git config --global --unset user.name "Your Name"
```

