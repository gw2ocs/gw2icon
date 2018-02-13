#!/bin/sh

git remote rm origin
git remote add origin https://Pandraghon:${GITHUB_TOKEN}@github.com/gw2ocs/gw2icon.git
git fetch
git checkout -b build origin/build
git rev-parse --abbrev-ref HEAD
git clean -fdx
rm -rf img
rm -rf css
git checkout master -- build/*
mv build/* .
rm -rf build
rm css/gw2icon.min.css.map
git rev-parse --abbrev-ref HEAD
git add .
git rev-parse --abbrev-ref HEAD
git commit -m "Update build $TRAVIS_COMMIT"
git rev-parse --abbrev-ref HEAD
git push origin HEAD:build
git checkout master
