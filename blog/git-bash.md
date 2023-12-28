# Git Bash - a handy Bash shell for Windows

Git Bash is a MINGW64 Bash shell optionally included with Git For Windows. It's a handy way to have a Bash shell in a Windows environment. Of course these days you could use the Windows 10 WSL (Windows Subsystem for Linux) to run a full-fledged Linux distro but I find Git Bash gets the job done and I've used it for many years. However there are a few gotchas. Read on to learn how to overcome them.

## Gotchas

If it hangs up when you run commands like `python` or `pytest`, try putting `winpty` in front of them or even better, set up some aliases in your bash profile:
```
echo "alias python='winpty python.exe'" >> ~/.bashrc
echo "alias pytest='winpty pytest.exe'" >> ~/.bashrc
echo "alias docker='winpty docker.exe'" >> ~/.bashrc
```
You will need to exit and reopen Git Bash shell for the alias to take effect.

### Docker with Git Bash

Another issue I've encountered is that when you're doing a `docker run` in interactive mode it fails to find `/bin/sh` but this can be easily solved by using `//bin//sh` instead. Observe:

`/bin/sh` doesn't work:
```
brett_svql3er@DESKTOP-Q20M58F MINGW64 ~/Git/uvicorn-gunicorn-sklearn-docker (master)
$ docker run -it bretttolbert/uvicorn-gunicorn-sklearn:python3.8-alpine3.10 /bin/sh
docker: Error response from daemon: OCI runtime create failed: container_linux.go:367: starting container process caused: exec: "C:/Program Files/Gi
t/usr/bin/sh.exe": stat C:/Program Files/Git/usr/bin/sh.exe: no such file or directory: unknown.
```

`//bin//sh` Works:
```
brett_svql3er@DESKTOP-Q20M58F MINGW64 ~/Git/uvicorn-gunicorn-sklearn-docker (master)
$ docker run -it bretttolbert/uvicorn-gunicorn-sklearn:python3.8-alpine3.10 //bin//sh
/app #
```

### Java with git-bash

The PATH environment variable determines which Java JRE will be used.

```
echo $PATH
java -verbose
export PATH=/d/jre-1.8.0/bin:$PATH
java -verbose
```

Tip: If you ever run into issues like "`/bin/sh` program not found", try `//bin//sh` or just `sh`.