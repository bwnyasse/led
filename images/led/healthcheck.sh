#!/bin/sh
while ! curl -s localhost:9200/  > /dev/null
do
echo "$(date) - still waiting for ES to be up and running"
sleep 1
done
echo "$(date) - ES is up and running"
