#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

SOURCE_BRANCH="master"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo -e "\e[36m\e[1mBuild triggered from a PR or another branch than \"${SOURCE_BRANCH}\" - not commiting"
    exit 0
fi

npm run build

REPO=`git config remote.origin.url`
echo $REPO

REPO="https://Pandraghon:${GITHUB_TOKEN}@github.com/gw2ocs/gw2icon.git"

git remote rm origin
git remote add origin $REPO

CURRENT_DIR=$PWD

TARGET_BRANCH="build"
git clone $REPO out_$TARGET_BRANCH -b $TARGET_BRANCH

cd out_$TARGET_BRANCH
. "$TARGET_BRANCH.sh"

cd $CURRENT_DIR
rm -rf out_$TARGET_BRANCH


TARGET_BRANCH="gh-pages"
git clone $REPO out_$TARGET_BRANCH -b $TARGET_BRANCH

cd out_$TARGET_BRANCH
. "$TARGET_BRANCH.sh"

cd $CURRENT_DIR
rm -rf out_$TARGET_BRANCH
