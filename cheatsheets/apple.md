# Apple

## Terminal

### Screenshots

    defaults write com.apple.screencapture type png

## Not to sleep

Go to sleep after 2 hours

    Caffeinated -u -t 7200

## Finder

### Show fullpath

    defaults write com.apple.finder _FXShowPosixFilePathInTitle -bool YES;killall Finder

## Developer portal

* [Apple Developer Portal](https://developer.apple.com/)


## MacBook

### Reboot in Recovery Mode

* Reboot your Mac into Recovery Mode by restarting your computer and holding down Command+R until the Apple logo appears on your screen.
* Click Utilities > Terminal.
* In the Terminal window, type in csrutil disable and press Enter.
* Restart your Mac.
