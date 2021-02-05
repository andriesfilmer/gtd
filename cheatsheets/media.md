# Webcam with background

### OBS studio

    sudo apt install obs-studio
    sudo apt install ffmpeg

Resourses: <https://obsproject.com/wiki/install-instructions#ubuntu-installation>

### Create a loopback video device

    sudo apt install linux-generic
    sudo apt install v4l2loopback-dkms

    sudo rmmod v4l2loopback #if you need to reload it for some reason
    sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1

    v4l2-ctl --list-devices

### Create a virtual webcam for OBS Studio

    sudo apt install qtbase5-dev
    git clone --recursive https://github.com/obsproject/obs-studio.git
    git clone https://github.com/CatxFish/obs-v4l2sink.git
    cd obs-v4l2sink
    mkdir build && cd build
    cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
    make -j4
    sudo make install

At first the OBS Studio could not found the new menu item "Tools"->"V4L2 Video Output"

   sudo cp /usr/lib/obs-plugins/v4l2sink.so /usr/lib/x86_64-linux-gnu/obs-plugins/

Now you can start OBS Studio and configure the V4L2 video output to /dev/video10 via the new menu item "Tools"->"V4L2 Video Output":

Play video on 'OBS Cam' for testing

    ffmpeg -re -i ~/Videos/moving-blocks-1.mp4 -f v4l2 /dev/video10

### Create a scene in OBS

- 1 Sources -> Add Video caputure device (V4L2)
- 2 Select the new video source and add a filter -> 'Chroma key'
- 3 Select the new filter and adjust it
- 4 Add a image or video source
- 5 Start new video output 'OBS cam' via the new menu item "Tools"->"V4L2 Video Output"

Start a webcam with the virtual device.

    cheese --device='OBS Cam'

#### Load `v4l2loopback` on reboot

    sudo vi /etc/modprobe.d/v4l2loopback.conf

Add

    options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1

Github: <https://github.com/umlaeute/v4l2loopback>


#### Extra

    v4l2-compliance -d /dev/video0
    v4l2-ctl -d /dev/video0 --list-ctrls
    v4l2-ctl --set-ctrl=zoom_absolute=150 -d /dev/video0

Resources:

* <https://blog.jbrains.ca/permalink/using-obs-studio-as-a-virtual-cam-on-linux>
* <https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html>


### Obs greenscreen video

Use a green screen: <https://www.youtube.com/watch?v=3A4B-kQdUt8>


## Video download

### youtube-dl

<https://github.com/rg3/youtube-dl>

    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' url
