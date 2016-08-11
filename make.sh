CURRENT=$(pwd)

echo 'Build UI Dart2JS'
cd $CURRENT/ui && pub get && pub build --mode=release

## Clean Previous ui
echo 'Clean Previous www content'
rm -rf $CURRENT/images/led/www

## Copy Ui output to docker image dir
echo 'Update www content'
mkdir $CURRENT/images/led/www
mv $CURRENT/ui/build/web/* $CURRENT/images/led/www/

## Build fluentd LED docker image
## TODO

## Dev mode launch compose-explorer

cd $CURRENT/compose-explorer && docker-compose build && docker-compose up --force-recreate

# Clean
rm -rf $CURRENT/images/fluentd-led/www/
