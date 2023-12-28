# How to trick pip into listing every available version of a package

If you have pip version >= 21.1 or < 20.3, it's easy-- simply `pip install` the package with a `==` on the end of the package name. E.g. `pip install pylama==`
Don't worry, it won't actually install the package because it'll fail with an error like the one below:

> $ pip install pylama==
ERROR: Could not find a version that satisfies the requirement pylama== (from versions: 0.1.0, 0.1.1, 0.1.2, 0.1.3, 0.1.4, 0.2.0, 0.2.1, 0.2.2, 0.2.3, 0.2.4, 0.2.5, 0.2.6, 0.2.7, 0.2.8, 0.3.0, 0.3.1, 0.3.2, 0.3.3, 0.3.4, 0.3.5, 0.3.6, 0.3.7, 0.3.8, 1.0.0, 1.0.1, 1.0.2, 1.0.4, 1.1.0, 1.1.1, 1.2.0, 1.3.0, 1.3.1, 1.3.2, 1.3.3, 1.4.0, 1.5.0, 1.5.1, 1.5.3, 1.5.4, 2.0.0, 2.0.1, 2.0.2, 2.0.3, 2.0.4, 3.0.1, 3.0.2, 3.1.0, 3.1.2, 3.2.0, 3.3.0, 3.3.1, 3.3.2, 4.0.0, 4.0.1, 4.0.2, 5.0.0, 5.0.1, 5.0.2, 5.0.3, 5.0.4, 5.0.5, 6.0.0, 6.0.1, 6.1.0, 6.1.1, 6.1.2, 6.2.0, 6.3.0, 6.3.1, 6.3.2, 6.3.3, 6.3.4, 6.4.0, 7.0.0, 7.0.3, 7.0.4, 7.0.6, 7.0.7, 7.0.9, 7.1.0, 7.2.1, 7.2.2, 7.2.3, 7.3.0, 7.3.1, 7.3.2, 7.3.3, 7.4.0, 7.4.1, 7.4.2, 7.4.3, 7.5.0, 7.5.5, 7.6.2, 7.6.4, 7.6.5, 7.6.6, 7.7.0, 7.7.1)
ERROR: No matching distribution found for pylama==

From this error output we can see that the latest version of pylama is 7.7.1.
 
If you have an older version of pip, consider upgrading:

`python -m pip install --upgrade pip`

To check your pip version

```
$ pip -V
pip 21.1.2 from c:\users\brett\appdata\local\programs\python\python39\lib\site-packages\pip (python 3.9)
```

If you're stuck with a pip version >= 20.3 and < 21.1, you'll need to use the `legacy-resolver` flag:

`pip install --use-deprecated=legacy-resolver pylama==`

