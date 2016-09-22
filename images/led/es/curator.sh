#!/bin/sh
curator --host localhost delete indices --older-than 7 --time-unit days --timestring '%Y.%m.%d'
