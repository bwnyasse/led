#!/bin/bash

#======= Multilines
MULTI_LINES="Write multilines : \n"
MULTI_LINES+="line1\n"
MULTI_LINES+="line2\n"
MULTI_LINES+="line3\n"
MULTI_LINES+="line4\n"

echo  -e "$MULTI_LINES" >&2
