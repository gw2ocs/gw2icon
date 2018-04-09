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
#. "$TARGET_BRANCH.sh"
rm -rf img
rm -rf css
rm -rf scss
cp -r $CURRENT_DIR/_build/* .
if ! git diff-index --quiet HEAD --; then
    echo -e "Commiting"
    git add .
    git commit -m "Update build $TRAVIS_COMMIT"
    git push $REPO HEAD:build
else
    echo -e "Nothing to commit, skipping"
fi

cd $CURRENT_DIR
rm -rf out_$TARGET_BRANCH


TARGET_BRANCH="gh-pages"
git clone $REPO out_$TARGET_BRANCH -b $TARGET_BRANCH

cd out_$TARGET_BRANCH
#. "$TARGET_BRANCH.sh"
rm -rf img
rm -rf css
rm -rf js
rm -rf webfonts
cp -r $CURRENT_DIR/docs/* .
cp -r $CURRENT_DIR/_build/css/* css/
cp -r $CURRENT_DIR/_build/img/* img/
if ! git diff-index --quiet HEAD --; then
    echo -e "Commiting"
    git add .
    git commit -m "Update docs $TRAVIS_COMMIT"
    git push $REPO HEAD:gh-pages
else
    echo -e "Nothing to commit, skipping"
fi

cd $CURRENT_DIR
rm -rf out_$TARGET_BRANCH
