#!/bin/bash
# Build a zip archive with wondercms files

CDATE=`date "+%Y-%m-%d"`
# change this to master once the dev branch has been merged
BRANCH=dev
# change this to the proper location of the zip file
ZIP_PATH=`pwd`/out
ZIP_FILE=$ZIP_PATH/wondercms_$BRANCH-$CDATE.zip

TMP_DIR=tmp/wondercms_$BRANCH-$CDATE

# attempt to make tmp directory if does not exist
if [ ! -d "$TMP_DIR" ]; then
    mkdir -p "$TMP_DIR"
fi

# get the latest files
git clone --depth 1 -b "$BRANCH" https://github.com/robiso/wondercms "$TMP_DIR"

cd "$TMP_DIR"
# install javascript dependencies
yarn install
# minify JS and CSS
grunt
# install php dependencies
composer install

# make zip archive
# but first remove the previous one (or it will just append to it)
if [ -f "$ZIP_FILE" ]; then
    rm "$ZIP_FILE"
fi
# also attempt to make zip path if does not exist
if [ ! -d "$ZIP_PATH" ]; then
    mkdir -p "$ZIP_PATH"
fi

zip -r "$ZIP_FILE" assets index.php plugins src/classes themes vendor version

if [ -f "$ZIP_FILE" ]; then
    echo "Build in $TMP_DIR successful!"
    echo "Output: $ZIP_FILE"
fi
