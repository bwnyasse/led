echo 'Build UI Dart2JS'
cd ui && pub build --mode=release && cd ..

## Clean Previous ui
echo 'Clean Previous www content'
rm -rf images/fluentd-es/www/*

## Copy Ui output to docker image dir
echo 'Update www content'
mv ui/build/web/* images/fluentd-es/www/

## Build fluentd LED docker image
## TODO

## Dev mode launch compose-explorer
cd compose-explorer && docker-compose build  && docker-compose up --force-recreate
