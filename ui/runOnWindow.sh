#!/bin/sh
#===========================================================================================================#
#title           :runOnWindow.sh
#description     :Script used to facilitate used of pub on sh bash over windows  ( consoleZ, git bash ...)
#author		       :bwnyasse
#=========================================================================================================#

# Ensure presence of DART_HOME env var.
[[ -z $DART_HOME ]] && echo "Error: env var named DART_HOME must be present to used this script :DART_HOME=PATH_TO_DARK_SDK" && exit 1
pub="dart $DART_HOME/bin/snapshots/pub.dart.snapshot"

usage() {
	cat <<-EOF

	usage: ./runOnWindow [compil|get|serve|test|repair]

	Script used to easy dev tasks on windows.

	OPTIONS:
	========
      compil      Launch dart2js in release mode. Result in build directory
      get         Equals to 'pub get'
      serve       Equals to 'pub serve' . Used port is: 8081
      test        Equals to 'pub run test', Launch Unit tests
      repair      Equals to 'pub cache repair'
      -h|help     Show this help

	EXEMPLE:
	========
		./runOnWindow compil
	EOF
}

# Read input
option="${1}"

case $option in

  compil)
      $pub get  && $pub run test test/  && $pub build --mode=release
      ;;
  get)
    $pub get
      ;;
  serve)
    $pub serve web --port=8081
      ;;
  test)
    $pub run test test/
      ;;
	repair)
		$pub cache repair
		;;
	*|-h|help)
		usage
		exit 1
		;;
esac
