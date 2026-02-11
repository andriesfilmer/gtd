# Keyboards

## Via
* [Keyboard configuration](https://usevia.app/)  usevia.app

## Keychron K10 Max QMK Wireless Mechanical Keyboard

* <https://www.keychron.com/products/keychron-k10-max-qmk-wireless-mechanical-keyboard>
* <https://launcher.keychron.com/#/keymap>
* <https://www.keychron.com/blogs/news/how-to-use-launcher-to-program-your-keyboard>

## Skyloong GK61 PRO_48

* https://skyloong.vip/blogs/news/skyloong-gk61-pro-user-guide

* Open `chrome://device-log/`
* See which device has FILE_ERROR_ACCESS_DENIED
* If /dev/hidraw4, then `sudo chmod 777 /dev/hidraw4`

### Hard Reset (Unplug Method)

* If the keyboard is unresponsive, use this method:
* Unplug the USB cable from the keyboard.
* Hold down the ESC key.
* While holding ESC, plug the USB cable back in.
* Hold for about 5 seconds until the keyboard flashes.

## Use via AppImage

    sudo apt install libfuse2

Download the latest version <https://github.com/the-via/releases/releases/>

    chmod +x via-*.AppImage
    ./via-3.0.0-linux.AppImage --no-sandbox

### Troubleshooting

* Go to chrome://settings/content/all
* Search for usevia.app
* Delete all data for that site
* Close and reopen the browser

Enable WebHID flag (if needed) Go to:

    Chrome: chrome://flags/#enable-experimental-web-platform-features

Set it to Enabled, then restart the browser.

### My current layers

Layer 0

![keyboard-layer-0](../images/keyboard/keyboard-layer-0.png)
Layer 1

![keyboard-layer-1](../images/keyboard/keyboard-layer-1.png)
Layer 2

![keyboard-layer-2](../images/keyboard/keyboard-layer-2.png)


If you want to save the current layout (json) and using Brave as a browser you can get this
to work by activating the `brave://flags/#file-system-access-api` experimental flag.

## QMK Firmware
* [Basic keycodes](https://docs.qmk.fm/keycodes)


## Home Row Mods
* [A guide to home row mods](https://precondition.github.io/home-row-mods#using-home-row-mods-with-qmk)

## Layout sizes

Keyboard layout 60%

![keyboard-layout 60%25](../images/keyboard/Keyboard-layout_60%_61-keys.png)

Keyboard layout 75%

![keyboard-layout 75%25](../images/keyboard/Keyboard-layout_75%.png)

Keyboard layout 80%

![keyboard-layout 80%25](../images/keyboard/Keyboard-layout_Tkl-80%.png)

Keyboard layout 100%

![keyboard-layout 100%25](../images/keyboard/Keyboard-layout_fullsize-100%_104-keys.png)

