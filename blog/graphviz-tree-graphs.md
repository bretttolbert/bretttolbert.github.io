# Creating tree graphs with graphviz

In this episode we'll be creating tree graphs using the graphviz DOT language. 

First we need to install the graphviz package:
```
sudo apt install -y graphviz
```

Now we'll create a simple graph. Copy the following DOT language into a file named `life.gv`:
```
digraph D {
  Life -> {Bacteria, Archaea, Eukaryota}
  Eukaryota -> {Plants, Fungi, Animals}
  Plants -> {Gymnosperms, Angiosperms}
  Animals -> {Vertebrates, Invertebrates}
  Vertebrates -> {Fish, Amphibians, Reptiles, Birds, Mammals}
}
```

Now we can generate a postscript file (similar to a pdf) with the following command:
```
dot -Tps life.gv -o life.ps
```
We can also generate a PNG image file with this command:
```
dot -Tpng life.gv -o life.png
```

![life.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1627223890233/54jVdFQfs.png)


