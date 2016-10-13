#!/bin/sh

set -e

source logger.sh
source cron_curator_routine.sh

# Retrievethe schedule , if not set , retrieve the default env var value
INPUT_1=$1
SCHEDULE=${INPUT_1:-$ES_CURATOR_SCHEDULE}
export ES_CURATOR_SCHEDULE=$SCHEDULE

# Retrievethe schedule , if not set , retrieve the default env var value
INPUT_2=$2
OLDER_THAN=${INPUT_2:-$ES_CURATOR_DAY_OLDER_THAN}
export ES_CURATOR_DAY_OLDER_THAN=$OLDER_THAN

crontab -r
inf "Update curator mechanism"
install_cron
