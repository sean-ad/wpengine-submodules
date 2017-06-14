#!/usr/bin/env bash

###
# Deploy to WPEngine environment from a project with private submodule dependencies
# because WPEngine only supports public submodules at the current time
# Local workstation Linux / MacOSX only
# Make sure you have your keys set up at WPEngine first,
# and that Git Push is enabled
#
# What this script does:
# 1. Checks out the project into a temporary directory
# 2. Retrieves the submodules
# 3. Pushes the newly-built temporary repo to WPEngine
# 4. Cleans up
#
# Thanks to https://github.com/hello-jason/bedrock-deploy-to-wpengine for the idea
###

if [ -z "$1" ]
  then
    echo "Please specify an environment (staging/production)"
    exit 1
fi

environment=$1

if [ -z "$2" ]
  then
    echo "Please specify a Github branch"
    exit 1
fi

branch=$2

###
# Create "/tmp/deploy" directory
# If necessary, remove existing directory
###
if [ -d "/tmp/deploy" ]
then
  echo "Removing old deployment directory."
  rm -Rf "/tmp/deploy"
fi
echo "Preparing files for deployment."
cp -a . "/tmp/deploy"
cd "/tmp/deploy"
git checkout ${branch}

###
# Create a temporary wpengine branch and retrieve submodule dependencies
###
exists=`git show-ref refs/heads/wpengine`
if [ -n "$exists" ]
then
  git branch -D wpengine
fi
git checkout -b wpengine
git submodule update --init --recursive

###
# Commit new structure into temporary git, and push to remote.
###
git add .
git commit -am "WP Engine build from: $(git log -1 HEAD --pretty=format:%s)$(git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/@\1/")"

echo " "
git_push="push $environment $branch --force"
echo "Pushing to WP Engine using: $git_push"
echo " "
git $git_push
echo "Successfully deployed."

###
# Remove temporary deploy directory
###
echo "Cleaning up..."
cd "../"
rm -Rf "../deploy"

echo "Done."

