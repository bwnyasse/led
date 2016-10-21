#!/bin/bash

source common.sh

set -e

while ! curl -s localhost:9200/  > /dev/null
do
log_info "Still waiting for ES to be up and running"
sleep 1
done
log_info "LED - ES is up and running"
