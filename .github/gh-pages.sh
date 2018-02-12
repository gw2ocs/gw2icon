#!/bin/sh

curl -v -H "Authorization: token $GITHUB_TOKEN" https://github.com
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
git commit -m "Update docs"
git push origin HEAD:gh-pages
git checkout master
