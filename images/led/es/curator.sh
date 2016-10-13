#!/bin/sh

INPUT=$1
OLDER_THAN=${INPUT:-$ES_CURATOR_DAY_OLDER_THAN}

curator --host localhost delete indices --older-than $OLDER_THAN --time-unit days --timestring '%Y.%m.%d'
