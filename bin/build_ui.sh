#!/bin/bash
#============================================================================================================#
#title           :build_ui.sh
#description     :Script used to build UI from Dart2JS compilation and update the files for LED docker image
#author		       :bwnyasse
#===========================================================================================================#
set -e

CURRENT_PATH=$(pwd)
INTEGRATION_PATH=$CURRENT_PATH/integ
UI_PATH=$CURRENT_PATH/ui
IMAGES_PATH=$CURRENT_PATH/images
LED_WWW=$IMAGES_PATH/led/www/

echo 'Build UI Dart2JS'
cd $UI_PATH && pub get && pub build --mode=release

## Clean Previous ui
echo 'Clean Previous www content'
rm -rf $CURRENT_PATH/images/led/www

## Copy Ui output to docker image dir
echo 'Update www content'
mkdir $CURRENT_PATH/images/led/www
mv $UI_PATH/build/web/* $LED_WWW

#git add $UI_PATH && git add $LED_WWW
