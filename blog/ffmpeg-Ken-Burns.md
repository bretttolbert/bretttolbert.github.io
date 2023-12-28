# Using ffmpeg to a make TikTok video with a SoundCloud-style Ken Burns panning effect

Use case: you want to upload your OC music recording to TikTok but you only have audio and TikTok requires video. What to do? Well, you can find a high-resolution image and generate a video from it and your recorded audio file using ffmpeg. Here's how:

Demo: [TikTok video made using ffmpeg](https://vm.tiktok.com/ZTd9713QN)

Here's the ffmpeg command used to create the above TikTok video:

```plaintext
ffmpeg -loop 1 -i tracks_4850x3591.jpg -i tracks.wav \
	-c:a aac -b:a 128k -c:v libx264 \
	-shortest -aspect 9:16 -s 1080x1920 \
	-vf crop=1080:1920:'t*(iw-ow)/165':'(ih-oh)/2' \
	-pix_fmt yuv420p out.mp4
```

Explanation:

* `165` is the duration of the audio file in seconds and we're using it to control the duration of the panning effect
    
* `1080x1920` is the native resolution for vertical TikTok videos. Your input image needs to be higher resolution than this in order to be able to crop a 1080x1920 image from it and then pan from one side to the other
    
* The four arguments expected by the `crop` command are `width`, `height`, `x`, and `y`
    
* `'t*(iw-ow)/165'` is the variable `x` argument and this makes it move from left to right based on time `t`
    
* `'(ih-oh)/2'` is the constant `y` argument and it makes the cropped image centered vertically with respect to the input image
