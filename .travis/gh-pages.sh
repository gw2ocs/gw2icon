#!/bin/sh

rm -rf img
rm -rf css
rm -rf js
rm -rf webfonts
cp $CURRENT_DIR/docs/* .
cp $CURRENT_DIR/_build/css/* css/
cp $CURRENT_DIR/_build/img/* img/
git add .
git commit -m "Update docs $TRAVIS_COMMIT"
git push $REPO HEAD:gh-pages
