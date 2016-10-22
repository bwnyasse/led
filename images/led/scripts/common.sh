#!/bin/bash

set -e

exec 3>&2 # logging stream (file descriptor 3) defaults to STDERR

readonly VERBOSITY=5 # default to show warnings
readonly SILENT_LVL=0
readonly CRT_LVL=1
readonly ERR_LVL=2
readonly WRN_LVL=3
readonly INF_LVL=4
readonly DBG_LVL=5

log_notify() {
  log $SILENT_LVL "[NOTE][LED]: $1";
}

log_critical() {
  log $CRT_LVL "[CRITICAL][LED]: $1";
}

log_error() {
  log $ERR_LVL "[ERROR][LED]: $1";
}

log_error_and_exit() {
  log_error $1
  exit 1
}

log_warn() {
  log $WRN_LVL "[WARNING][LED]: $1";
}

log_info() {
  log $INF_LVL "[INFO][LED]: $1";
}

log_debug() {
  log $DBG_LVL "[DEBUG][LED]: $1";
}

log() {
    if [[ $VERBOSITY -ge $1 ]]; then
        datestring=`date +'%Y-%m-%d %H:%M:%S'`
        # Expand escaped characters, wrap at 70 chars, indent wrapped lines
        echo -e "$datestring $2" | fold -w150 -s  >&3
    fi
}


install_curator_cron() {
  echo "Install Curator Cron with schedule $ES_CURATOR_SCHEDULE for older than $ES_CURATOR_DAY_OLDER_THAN days"
  if ! [ -f curator-cron ]
  then
    log_info "Creating cron entry to start curator at: $ES_CURATOR_SCHEDULE for older than $ES_CURATOR_DAY_OLDER_THAN days"
    # Note: Must use tabs with indented 'here' scripts.
    cat <<-EOF >> curator-cron
$ES_CURATOR_SCHEDULE led_curator > /var/log/led/curator.log 2>&1
EOF
    crontab curator-cron
    crond
  fi
}
