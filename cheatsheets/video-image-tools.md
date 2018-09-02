# Video and Image tools

## RecordMyDesktop

    sudo apt install recordmydesktop gtk-recordmydesktop

Capture right side of screen

    recordmydesktop --width 1280 --height 720 -x 1840 -y 215 --fps 25 --channels 1 --device pulse --delay 3 -o Desktop/screencast
    ffmpeg -f alsa -ac 2 -i pulse -f x11grab -show_region 1 -r 30 -s 1280x720 -i :1.0+1840,220 -acodec pcm_s16le -vcodec libx264 Desktop/capture.mkv
    ffmpeg -f alsa -ac 2 -i pulse -f x11grab -show_region 1 -r 25 -s 1280x720 -i :1.0+1840,220 -acodec pcm_s16le -vcodec libx264 -threads 0 -pix_fmt yuv420p -movflags faststart Desktop/capture.mkv

* Allow your cpu use optimal number of threads: -threads 0
* QuickTime compatibility:  -pix_fmt yuv420p. 
* Fast start: -movflags +faststart.

##  SimpleScreenRecorder
A GUI Linux program to record programs and games. [Maarten Baert](http://www.maartenbaert.be/simplescreenrecorder/)

## Byzanz records your desktop session to an animated GIF on the command line.

You can record  your entire screen, a single window, or an arbitrary  region.byzanz record  allows you to make recordings from the command line.  Graphical  users may want to use the panel applet instead.

## ImageMagic

### Convert order and resize Images on the commandline

    sudo apt-get install imagemagick
    find . -maxdepth 1 -iname "*.jpg" -print0 | xargs -0 -l -i convert -resize 1024x768 -quality 50 -strip {} /tmp/output/{}

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
