#!/bin/zsh
# Open an html attachement in your browser of choice
# OSX only, but y'know... can be tweaked
# (s/open/xdg-open)
tee /tmp/$1 > /dev/null && open /tmp/$1