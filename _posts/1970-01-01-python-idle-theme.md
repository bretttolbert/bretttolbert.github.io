---
layout: post
title:  "How to add Monokai dark highlighting theme to IDLE Python Shell"
date:   1970-01-01 00:00:00 -0600
categories: dev
---

Want to make your IDLE Python Shell look like Sublime Text's default theme (Monokai)? Here's how:

First find your `.idlerc` folder. On Windows, you can get there by going to `%userprofile%\.idlerc`

Next copy the following config into a new text file in the `.idlerc` directory with the filename `config-highlight.cfg`:

```bash
# Place this  file inside your ~/.idlerc/ folder
# or paste its contents inside 
# /path/to/python/idlelib/config-highlight.def
# Adapted from SublimeText's Monokai

[monokai]
normal-foreground= #F8F8F2
normal-background= #272822
keyword-foreground= #F92672
keyword-background= #272822
builtin-foreground= #66D9EF
builtin-background= #272822
comment-foreground= #75715E
comment-background= #272822
string-foreground= #FD971F
string-background= #272822
definition-foreground= #A6E22E
definition-background= #272822
hilite-foreground= #F8F8F2
hilite-background= gray
break-foreground= black
break-background= #ffff55
hit-foreground= #F8F8F2
hit-background= #171812
error-foreground= #ff3338
error-background= #272822
cursor-foreground= #F8F8F2
stdout-foreground= #DDDDDD
stdout-background= #272822
stderr-foreground= #ff3338
stderr-background= #272822
console-foreground= #75715E
console-background= #272822
```

Now you just need to restart IDLE and go to Options -> Configure IDLE -> Highlights -> Highlighting Theme -> a Custom theme and choose `monokai`.

Credit to [Jaime Rodríguez-Guerra](https://gist.github.com/jaimergp/10285906) for this custom theme.
