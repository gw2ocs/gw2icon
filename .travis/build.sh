#!/bin/sh

rm -rf img
rm -rf css
rm -rf scss
cp $CURRENT_DIR/_build/* .
git add .
git commit -m "Update build $TRAVIS_COMMIT"
git push $REPO HEAD:build
