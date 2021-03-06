#!/bin/bash
#===================================================================================================#
#title           :build_all_dev.sh
#description     :Build everything for dev and create latest docker images locally
#author		       :bwnyasse
#==================================================================================================#

cd ..
CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ/dev
UI_PATH=$CURRENT/ui
IMAGES_PATH=$CURRENT/images
LED_WWW=$IMAGES_PATH/led/www/

$CURRENT/build_ui.sh

## Build fluentd LED docker image
## Dev mode launch compose-explorer
cd $IMAGES_PATH/led && docker build -t bwnyasse/led .

# Clean
#rm -rf $IMAGES_PATH/fluentd-led/www/
