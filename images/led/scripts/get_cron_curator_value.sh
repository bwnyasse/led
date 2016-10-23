#!/bin/bash

set -e

source common.sh


usage() {
	cat <<-EOF

  Script used to retrieve current cron curator settings

	EOF
}

NAME=$1
[[ -n $NAME ]] || exit 1;
POSITION=$2
[[ -n $POSITION ]] || exit 1;
KEY_VALUE_LINE=$(crontab -l | sed -n "$POSITION"p)
set -- "$KEY_VALUE_LINE"
OIFS=$IFS; IFS="="; #Sauvegarde de l'ancien IFS et initialisation du nouveau
declare -a Array=($*)
IFS=$OIFS  # Restaure IFS.
[[ "${Array[0]}" != $NAME ]] && exit 1;
echo "${Array[1]}"
