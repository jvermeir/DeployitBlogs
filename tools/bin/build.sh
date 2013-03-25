#! /bin/bash

CURR=`PWD`
APP=$1
echo "Generating deployment archive for '$APP'"

DEPLOYIT_HOME=/Users/jan/dev/blogs/deployitBlogs/deployit-3.8.4-server

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`
TMP=target/dar
if [ -d "$TMP" ]; then
	rm -rf $TMP
fi

mkdir -p $TMP/META-INF
cat src/main/resources/manifest.template | sed "s/<application>/$APP/g;s/<timestamp>/$TIMESTAMP/g" > $TMP/META-INF/MANIFEST.MF
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" > $TMP/resources/someFile.txt
echo $TIMESTAMP >> $TMP/someFile.txt
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> $TMP/resources/someFile.txt
cd $TMP
rm ../$APP.dar
zip -r ../$APP.dar *
cd $CURR

$DEPLOYIT_HOME/deployit-3.8.4-cli/bin/cli.sh -username admin -password admin -f deploy.cli -- $CURR/target/$APP.dar localenv
