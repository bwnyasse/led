#!/bin/sh

source logger.sh

set -e

while ! curl -s localhost:9200/  > /dev/null
do
inf "Still waiting for ES to be up and running"
sleep 1
done
inf "LED - ES is up and running"
