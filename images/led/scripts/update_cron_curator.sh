#!/bin/bash

set -e

source common.sh

usage() {
	cat <<-EOF

  Script used to update current curator cron mechanism

	EOF
}

# Retrievethe schedule , if not set , retrieve the default env var value
SCHEDULE=${1:-$ES_CURATOR_SCHEDULE}
[[ -n $SCHEDULE ]] && log_error_and_exit "Curator Cron schedule is not define"

# Retrievethe schedule , if not set , retrieve the default env var value
OLDER_THAN=${2:-$ES_CURATOR_DAY_OLDER_THAN}
[[ -n $OLDER_THAN ]] && log_error_and_exit "Curator clean days value is not define"

crontab -r
log_info "Update curator mechanism"
install_curator_cron $SCHEDULE $OLDER_THAN
