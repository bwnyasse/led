#!/bin/sh

source logger.sh

install_cron() {
  local schedule=$1
  echo "schedule $schedule"
  LOGFIFO='/var/log/cron.fifo'
  if [[ ! -e "$LOGFIFO" ]]; then
      mkfifo "$LOGFIFO"
  fi
  echo -e "$ES_CURATOR_SCHEDULE /curator.sh > $LOGFIFO 2>&1" | crontab -
  crond
  crontab -l
}
