#!/bin/bash
#
# @description
# Push Tag to github
#
# @author bwnyasse
##

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

mkdir code
cd code

git init
git config --global push.followTags true
git config user.name "builds@travis-ci.com"
git config user.email "Travis CI"

git remote add origin "https://$GH_TOKEN@github.com/bwnyasse/fluent-led.git"
git fecth upstream

# Add Travis commit to Dockerfile
sed -i '$ d' images/led/Dockerfile && echo 'Travis Build - GIT_SHA ${TRAVIS_COMMIT}' >> images/led/Dockerfile

git add -u
git commit -m "Update from TravisCI build $TRAVIS_BUILD_NUMBER"
git tag $VERSION -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
git push --follow-tags

cd ..
# # Now that we're all set up, we can push.
# git push $SSH_REPO $VERSION
#
# git config --global user.email "builds@travis-ci.com"
# git config --global user.name "Travis CI"
# git tag $VERSION -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
#
# # Save some useful information
# REPO=`git config remote.origin.url`
# SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
#
# # Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
# ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
# ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
# ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
# ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
# openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d
# chmod 600 deploy_key
# eval `ssh-agent -s`
# ssh-add deploy_key
#
# # Now that we're all set up, we can push.
# git push $SSH_REPO $VERSION
