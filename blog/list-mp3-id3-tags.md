# Bash one-liner: List mp3 music ID3v2 tag genre stats

ID3 is the language of the metadata in your mp3 (or m4a) files. There are two major versions of ID3 tags: ID3v1 and ID3v2. ID3v2 has many features such as custom genre tags. Gone are the days of ID3v1 which limited users to a small set of predefined genre tags.

I got frustrated with putting effort into playlists only to lose them, so I have decided to redirect my effort into getting my ID3v2 genre tags set to my liking in my offline library of some ~8000 tracks. Having the genre tag set to the specific sub-genre makes my library much more navigable. I don't really need playlists any more, but I can now easily create them by adding one or more genres in their entirety.

Some older tools like `mp3info` can´t read ID3v2 tags, and `id3v2` can't read ID3v2.4 tags, so I recommend `ffprobe`. Demo:

```
$ find /data/Music -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -exec ffprobe {} \; 2>&1 | egrep "genre" | sort | uniq -c | sort -rn -k1.4,7
   1182     genre           : Indie Rock
    915     genre           : Classic Rock
    586     genre           : Classic Prog
    475     genre           : Alternative Rock
    426     genre           : Funk Rock
    330     genre           : Country
    326     genre           : Post-Hardcore
    214     genre           : Electronica
    206     genre           : Classical
    204     genre           : Indie Folk
    173     genre           : Electropop
    173     genre           : Brett Tolbert
    158     genre           : Alternative Metal
    149     genre           : Post-Punk
    145     genre           : Pop Rock
    138     genre           : Emo / Pop-Rock
    127     genre           : Britpop
    124     genre           : New Wave français
    108     genre           : Post-Grunge
    100     genre           : Electronic (Instrumental)
     89     genre           : Hip-Hop
     83     genre           : Post-Punk Revival
     79     genre           : Folk Punk
     78     genre           : Desert Rock
     76     genre           : Other
     76     genre           : Funk (Instrumental)
     72     genre           : Grunge
     69     genre           : Pop-Punk
     65     genre           : Folk
     61     genre           : Rap Rock
     56     genre           : Southern Rock
     55     genre           : Post-Industrial
     54     genre           : Neo-Psychedelic Rock
     51     genre           : Pop
     46     genre           : Progressive Pop
     44     genre           : Punk français
     42     genre           : Soft Rock
     41     genre           : Post-Rock
     41     genre           : Electronic w/ vocals
     35     genre           : Indie Pop
     26     genre           : Punk
     26     genre           : Psychedelic Rock
     26     genre           : Industrial Metal
     26     genre           : Industrial
     24     genre           : Soundtrack
     22     genre           : Progressive Metal
     21     genre           : Punk Rock
     21     genre           : Math Rock
     20     genre           : Pop française
     17     genre           : Reggae
     17     genre           : Metal
     16     genre           : Heavy Metal
     15     genre           : Blues
     14     genre           : Indie
     13     genre           : Industrial Rock
     13     genre           : Dub
     12     genre           : Dream Pop
     12     genre           : Blues Rock
     11     genre           : R&B
     11     genre           : New Wave
     10     genre           : Reggae Rock
     10     genre           : Chillwave
      9     genre           : Rock français
      8     genre           : Experimental
      7     genre           : Progressive Rock
      7     genre           : Post-Black Metal
      6     genre           : Joey Buxton
      6     genre           : Funk Metal
      5     genre           : Folk Rock
      5     genre           : Backing Tracks
      4     genre           : Post-Metal
      3     genre           : Soul
      3     genre           : Gospel
      3     genre           : genre
      3     genre           : Folk Pop
      3     genre           : Drumline
      3     genre           : Comedy
      3     genre           : Bluegrass
      2     genre           : World
      2     genre           : Ska Punk
      2     genre           : Nu Metal français
      2     genre           : Nu Metal
      2     genre           : Metalcore
      2     genre           : Hip-Hop français
      1     genre           : Surf Rock
      1     genre           : Sports
      1     genre           : Miscellaneous
      1     genre           : Jazz
      1     genre           : Heartland Rock
      1     genre           : Grindcore
      1     genre           : Glam Rock
      1     genre           : General Country

```

For editing the ID3 tags of your files, I recommend Gnome `EasyTAG`. Gnome `Rhythmbox` also works.

For ripping CDs, I recommend `K3b`.


Addendum: Ignore my first attempt below using the `id3v2` command, as you can see, it was not counting most of my tags (id3v2.4?). `ffprobe` is the way to go, even though it's much slower.
```
$ find /data/Music -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -exec id3v2 -R {} \; | grep TCON | sed "s/TCON://" | sort | uniq -c | sort -rn -k1.4,7
    668  Classic Rock (1)
    568  Classic Prog (255)
    344  Funk Rock (255)
    287  Country (2)
    173  Brett Tolbert (255)
    131  Classical (32)
     99  Indie Folk (255)
     76  Other (12)
     54  Folk Punk (255)
     54  Folk (80)
     50  Electronica (255)
     35  Alternative Rock (255)
     30  Hip-Hop (7)
     28  Pop (13)
     26  Industrial (19)
     23  Soundtrack (24)
     19  Alternative Metal (255)
     15  Metal (9)
     15  Blues (0)
     14  Indie (131)
     12  Progressive Metal (255)
      9  Punk (43)
      9  New Wave (66)
      6  Grunge (6)
      5  R&B (14)
      3  Soul (42)
      3  Gospel (38)
      3  genre (255)
      3  Comedy (57)
      3  Bluegrass (89)
      2  Reggae (16)
      2  Punk Rock (121)
      1  Sports (255)
      1  Miscellaneous (255)
      1  Joey Buxton (255)
      1  Jazz (8)
      1  Heavy Metal (137)
      1  Heartland Rock (255)
      1  General Country (255)
      1  Electropop (255)
      1  Dream Pop (255)
      1  Chillwave (255)
```