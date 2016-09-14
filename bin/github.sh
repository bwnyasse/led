#!/bin/bash
#============================================================================================================#
#title           :github.sh
#description     :Enable action remetly on github
#author		       :bwnyasse
#===========================================================================================================#
set -o errexit -o nounset

# Push tag only if it's not a SNAPSHOT build
if  [[ "$TRAVIS_BRANCH" == "master" && "$VERSION" != *"SNAPSHOT"* ]]
then
  #echo "This commit was made against the $TRAVIS_BRANCH and the master! No deploy!"
  rev=$(git rev-parse --short HEAD)

  mkdir code
  cd code

  git init
  git config --global push.followTags true
  git config user.name "builds@travis-ci.com"
  git config user.email "Travis CI"

  git remote add origin "https://$GH_TOKEN@github.com/bwnyasse/led.git"
  git fetch origin
  git pull origin master

  #GIT_TAG=$VERSION-${TRAVIS_COMMIT:0:12}
  GIT_TAG=v$VERSION

  #git add -u
  #git commit -m "Update from TravisCI build $TRAVIS_BUILD_NUMBER"
  git tag $GIT_TAG -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
  git push --follow-tags

  cd ..
fi
