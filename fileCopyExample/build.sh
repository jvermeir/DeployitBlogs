#! /bin/bash

APP=$1
echo "Generating deployment archive for '$APP'"

DEPLOYIT_HOME=/Users/jan/dev/blogs/deployitBlogs/deployit-3.7.4-server

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`
TMP=target/dar
if [ -d "$TMP" ]; then
	rm -rf $TMP
fi

mkdir -p $TMP/META-INF
cat src/main/resources/manifest.template | sed "s/<application>/$APP/g;s/<timestamp>/$TIMESTAMP/g" > $TMP/META-INF/MANIFEST.MF
mkdir -p $TMP/resources
echo $TIMESTAMP > $TMP/resources/$TIMESTAMP.txt
cd $TMP
rm ../$APP.dar
zip -r ../$APP.dar *
cd -
cp target/$APP.dar $DEPLOYIT_HOME/importablePackages

echo "'$APP' copied, start Deploy gui and import"
