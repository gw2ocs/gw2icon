#!/bin/sh

SOURCE_BRANCH="master"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo -e "\e[36m\e[1mBuild triggered from a PR or another branch than \"${SOURCE_BRANCH}\" - not commiting"
    exit 0
fi

git remote rm origin
git remote add origin https://Pandraghon:${GITHUB_TOKEN}@github.com/gw2ocs/gw2icon.git
git fetch
git checkout -b gh-pages origin/gh-pages
git clean -fdx
rm -rf img
rm -rf css
rm -rf js
git checkout master -- docs/* build/*
mv docs/* .
rm -rf docs
mkdir -p css
mkdir -p img
mv build/css/gw2icon.min.css css/
mv build/img/gw2icon img/
rm -rf build
git add .
git commit -m "Update docs $TRAVIS_COMMIT"
git push origin HEAD:gh-pages
git checkout master
