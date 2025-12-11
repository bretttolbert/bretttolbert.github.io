---
layout: post
title:  "Bash Tip: How to recall a specific command from Bash history and edit it before executing it again"
date:   1970-01-01 00:00:00 -0600
categories: dev
---

In Bash, the `history` command displays previously executed statements. You can re-execute any line displayed in history by using `!` followed by the line number in the `history` output. E.g. `!499`. This will cause Bash to immediately re-execute that line. 

Oftentimes, however, you'll want to edit the line before re-executing it. In that case, you can add the `:p` suffix which tells Bash to just print the line instead of actually executing it. E.g. `!499:p`. Then you can just hit the Up-Arrow to recall the line you just re-printed, giving you the chance to edit it before pressing Enter.

You can also use `!-1` to immediately execute the previously executed command. This may not be any quicker than Up-Arrow Enter but it's useful for appending the previous command into a startup script, i.e. making it persistent:
```
export PATH=~/Scripts:$PATH
echo "!-1" >> ~/.bashrc
```