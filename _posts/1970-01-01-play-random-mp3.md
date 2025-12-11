---
layout: post
title:  "Bash one-liner: Play a random .mp3 or .m4a file"
date:   1970-01-01 00:00:00 -0600
categories: dev
---

Here's the one-liner:

```
find /data/Music -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -print | shuf -n 1 | xargs --delimiter '\n' vlc --play-and-exit
```

But rather than type all that every time we want to listen to music, let's put it in a script file, or rather three script files, and add a **repeat** feature:

`PrintAudioFiles`
```
#!/bin/bash
find "$1" -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -print
```

`Shuffle1`
```
#!/bin/bash
source PrintAudioFiles "$1" | shuf -n 1 | xargs --delimiter '\n' vlc --play-and-exit
```

`ShuffleForever`
```
#!/bin/bash
while :
do
    source Shuffle1 "$1"
done
```

Each of these three scripts can be executed independently. 

To shuffle music on repeat, we simply run `./ShuffleForever /data/Music`, where `/data/Music` is the path to your music library. 

To search, we can combine the `PrintAudioFiles` script with the `grep` command, e.g. `./PrintAudioFiles /data/Music | grep -i "modest mouse"`

To play something from the search results, we can simply copy/paste the filename and run `vlc`, for example: `vlc "/data/Music/Modest Mouse/Lonesome Crowded West/03 Convenient Parking.mp3"` (don't forget the double quotes)

See also:

- [Bash one-liner: List mp3 music ID3v2 tag genre stats](./list-mp3-id3-tags.md)
