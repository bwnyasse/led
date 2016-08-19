#!/bin/bash
#
# @description
# Script used to build projet and Test from DART2Js compilation
#
# @author bwnyasse
##
CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ
EXPLORER_PATH=$CURRENT/explorer
UI_PATH=$CURRENT/ui
IMAGES_PATH=$CURRENT/images

echo 'Build UI Dart2JS'
cd $UI_PATH && pub get && pub build --mode=release

## Clean Previous ui
echo 'Clean Previous www content'
rm -rf $CURRENT/images/led/www

## Copy Ui output to docker image dir
echo 'Update www content'
mkdir $CURRENT/images/led/www
mv $UI_PATH/build/web/* $IMAGES_PATH/led/www/

## Build fluentd LED docker image
## Dev mode launch compose-explorer
cd $IMAGES_PATH/led && docker build -t bwnyasse/fluentd-led . 

# Clean
rm -rf $IMAGES_PATH/fluentd-led/www/
