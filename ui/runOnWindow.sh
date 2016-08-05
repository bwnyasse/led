#!/bin/sh
#
# @description Script utilisée pour faciliter des actions de dev sur Windows ( serve , test , compil)
#
##

# Assure l'utilisation de pub sur Windows dans un bash ( consoleZ, git bash ...)
[[ -z $DART_HOME ]] && echo "Erreur: variable DART_HOME non renseignée. Elle doit être DART_HOME=PATH_VERS_REPERTOIRE_DART_SDK" && exit 1
pub="dart $DART_HOME/bin/snapshots/pub.dart.snapshot"

# Affiche le message d'aide définissant comment utiliser ce script
usage() {
	cat <<-EOF

	usage: ./runOnWindow [compil|get|serve|test|repair]

  Script utilisé pour faciliter les actions de dev.

	OPTIONS:
	========
      compil      Construit le projet via dart2js en mode release et le résultat js est dans le répertoire build
      get         Equivalent de 'pub get', télécharge ou met à jour les dépendances du projet
      serve       Equivalent de 'pub serve', sert l'application sur le localhost. Port par défaut : 8081
      test        Equivalent de 'pub run test', lance les TU
      repair      Equivalent de 'pub cache repair', nettoie le repository et retélécharge les librairies
      -h|help     Affiche ce message d'aide.

	EXEMPLE:
	========
		./runOnWindow compil
	EOF
}

# Lecture de l'input
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
