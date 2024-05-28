# Video and Image tools

## Compress images

Nice tool to make your images smaller. <https://squoosh.app/>

### PNG files

Or command line

    convert input.png -color 256 png8:output.png

or

    apt install pngquant
    pngquant --ext .compressed.png image.png
    pngquant 8 image.png -o image-8-colors.png

or whole dir

    pngquant *.png
    for i in *-fs8.png ; do mv $i "`echo $i | sed "s/-fs8//"`" ; done

### JPG files

    apt install jpegoptim

Run option -n to see results.

    convert input.jpg -strip -interlace Plane -gaussian-blur 0.05 -quality 50% output.jpg

or

    jpegoptim -m 50 --strip-all image.jpg
    find /path/to \( -iname \*.jpg -or -iname \*.jpeg \) -print0 | xargs -0 jpegoptim # recursively for each file

### Online

You can use also the [online compressor](https://compressor.io/)

## ffmpeg

Convert webm to mp4

    ffmpeg -i video.webm -preset veryfast video.mp4
    ffmpeg -fflags +genpts -i video.webm -r 24 video.mp4


Capture right side of screen

    ffmpeg -f alsa -ac 2 -i pulse -f x11grab -show_region 1 -r 30 -s 1280x720 -i :1.0+1280,244 -acodec pcm_s16le -vcodec libx264  /path/to/screencast.mkv


* Allow your cpu use optimal number of threads: -threads 0
* QuickTime compatibility:  -pix_fmt yuv420p.
* Fast start: -movflags +faststart.

When creating screencasts disable Flipping.

    nvidia-settings --assign="AllowFlipping=0"

### Rip a DVD to one file

 cat *.VOB > DVD.vob
 ffmpeg -i DVD.vob DVD1.mp4

or

 ffmpeg -i "concat:VTS_01_1.VOB|VTS_01_2.VOB|VTS_01_3.VOB" -target pal-dvd -vcodec copy -acodec copy OUTPUT_DVD.mp4


## ImageMagic

### Resize Images on the commandline

    sudo apt-get install imagemagick
    mogrify -resize 1280x853 *.jpg

Resize all photo as rectangle with the max width/height off the photo.

    for i in *.jpg; do convert $i -gravity center -crop `identify -format "%[fx:min(w,h)]x%[fx:min(w,h)]+0+0" $i` +repage resized_$i; done

Check the photos for remaming to orginal name (remove 'echo' if the output is oke).


    for filename in resized_*.jpg; do echo mv "$filename" "${filename//resized_/}"; done


### Auto orientation

Remove orientation

    mogrify -auto-orient -strip image.jpg

If you use ImmageMagick to make a fotoalbum or make a overview with thumbs you need to set the orientation first.

    cd /to/dir/with/fotos
    for i in *.JPG;do convert -auto-orient $i $i;done

### Crop images

    convert image.jpg -gravity Center -crop 50% re_image.jpg

Once I had made many screenshots from Google en I wanted to crop the images without the searchbar.

    for f in *.png ;do `convert $f -crop 1856x1175+0+190 "_$f"`;done

Convert a thumbnail 80x80 with (mostly) landscape images.

    convert image.jpg -resize x160 -resize '160x<'   -resize 50% -gravity center  -crop 80x80+0+0 +repage image-new.jpg

Convert a thumbnail 80x80 with (mostly) portrait images.

    convert image.jpg -resize 160x -resize 'x160<'   -resize 50% -gravity center  -crop 80x80+0+0 +repage image-new.jpg

### Make a album

Overview of  images in directory

    montage *.jpg -geometry 200x200+10+10 index.png

Fancy album

    montage *.jpg -bordercolor snow -background white +polaroid -geometry 200x200+2+2 -shadow -tile 5x -title 'Pelikaanlaan' index.html

## Nautilus and Image converter

We can also use Nautilus extention which uses ImageMagick.

    sudo apt-get install nautilus-image-converter

Login out/in (or killall nautilus) to get the new options when right-click on a image in Nautilus
Now you can resize or scale images with a mouse ;)

## AI image generators

* [Dall-E](https://openai.com/dall-e-2/)
* [Craiyon](https://www.craiyon.com/)
* [Midjourney](https://www.midjourney.com/)
* [Dreamstudio](https://beta.dreamstudio.ai)
* [NightCafe Creator](https://creator.nightcafe.studio/create)
* [Wombo Dream](https://dream.ai/create)
