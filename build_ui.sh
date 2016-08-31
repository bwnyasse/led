#!/bin/bash
#
# @description
# Script used to build UI from Dart2JS compilation and update the files for LED docker image
#
# @author bwnyasse
##
CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ
UI_PATH=$CURRENT/ui
IMAGES_PATH=$CURRENT/images
LED_WWW=$IMAGES_PATH/led/www/

echo 'Build UI Dart2JS'
cd $UI_PATH && pub get && pub build --mode=release

## Clean Previous ui
echo 'Clean Previous www content'
rm -rf $CURRENT/images/led/www

## Copy Ui output to docker image dir
echo 'Update www content'
mkdir $CURRENT/images/led/www
mv $UI_PATH/build/web/* $LED_WWW

git add $UI_PATH && git add $LED_WWW
