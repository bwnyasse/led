#!/bin/bash
#
# @description
# Build everything for dev and create latest docker images locally
#
# @author bwnyasse
##

CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ
UI_PATH=$CURRENT/ui
IMAGES_PATH=$CURRENT/images
LED_WWW=$IMAGES_PATH/led/www/

$CURRENT/build_ui.sh

## Build fluentd LED docker image
## Dev mode launch compose-explorer
cd $IMAGES_PATH/led && docker build -t bwnyasse/fluentd-led .

# Clean
#rm -rf $IMAGES_PATH/fluentd-led/www/
