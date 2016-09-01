#!/bin/bash
#
# @description
# Push Tag to github
#
# @author bwnyasse
##

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" == "master" ]
then
  #echo "This commit was made against the $TRAVIS_BRANCH and the master! No deploy!"
  rev=$(git rev-parse --short HEAD)

  mkdir code
  cd code

  git init
  git config --global push.followTags true
  git config user.name "builds@travis-ci.com"
  git config user.email "Travis CI"

  git remote add origin "https://$GH_TOKEN@github.com/bwnyasse/fluentd-led.git"
  git fetch origin
  git pull origin master

  # Add Travis commit to Dockerfile
  #sed -i '$ d' images/led/Dockerfile && echo 'Travis Build - GIT_SHA ${TRAVIS_COMMIT}' >> images/led/Dockerfile

  #git add -u
  #git commit -m "Update from TravisCI build $TRAVIS_BUILD_NUMBER"
  git tag $VERSION -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
  git push --follow-tags

  cd ..
fi
