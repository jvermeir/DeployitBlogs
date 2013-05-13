#!/bin/bash

#
# Create a fresh install of Deployit, copy available plugins and plugins taken from
# a build directory, start Deployit and check the log to see if it still works.
#
# Usage: ./basicDeployitStartupTest.sh [-r rootDirForInstall -d dirToInstallDeployit -p dirThatHoldsCustomPlugins -v deployitVersion plugin1 plugin2 ...]
# All parameters are optional, see parseopts for details
#

parseopts () {
    echo "parseopts"
    ROOTDIR=`PWD`
    DEPLOYIT_HOME=$ROOTDIR/target
    PLUGINS_SRC_DIR=$ROOTDIR/test/success
    DEPLOYIT_VERSION=3.8.4

	while getopts r:p:d:v: optname; do
	    case $optname in
	    r)
		  ROOTDIR=$OPTARG
		  ;;
	    d)
		  DEPLOYIT_HOME=$OPTARG
		  ;;
	    p)
		  PLUGINS_SRC_DIR=$OPTARG
		  ;;
	    v)
		  DEPLOYIT_VERSION=$OPTARG
		  ;;
	    *)
		  echo "Unknown error while processing options"
		  ;;
	    esac
	done
    shift $((OPTIND - 1))
    PLUGIN_NAMES="$@"
}

function findAndTerminateDeployitProces {
    echo "stop Deployit process"
	deployitProcess=`ps -aef|grep java | grep com.xebialabs.deployit.DeployitBootstrapper`
	set -- $deployitProcess
	pid=$2
	if [ "$pid" ]
	then
		kill $pid
	fi
}

function printEnv {
    echo "ROOTDIR: $ROOTDIR"
    echo "DEPLOYIT_HOME: $DEPLOYIT_HOME"
    echo "PLUGINS_SRC_DIR: $PLUGINS_SRC_DIR"
    echo "DEPLOYIT_VERSION: $DEPLOYIT_VERSION"
    echo "PLUGINS:"
    for plugin_name in $PLUGIN_NAMES
    do
        echo $plugin_name
    done
}

function installDeployit {
	echo "install Deployit"
	rm -rf $DEPLOYIT_HOME
	mkdir -p $DEPLOYIT_HOME
	unzip -q $ROOTDIR/resources/deployit-$DEPLOYIT_VERSION-server-setup.zip -d $DEPLOYIT_HOME
}

function buildAndCopyPlugins {
    echo "build and copy plugins"
    CURR=`PWD`
	echo "build"

	cd $PLUGINS_SRC_DIR

    echo "plugin_names: $PLUGIN_NAMES"
    echo "Start of build" > /tmp/build.log
    for PLUGIN in $PLUGIN_NAMES
    do
        cd $PLUGIN
        ./buildAndCopy.sh $DEPLOYIT_HOME/deployit-$DEPLOYIT_VERSION-server/ >> /tmp/build.log
        cd ..
    done
	BUILD_RESULT=-1
	case `cat /tmp/build.log` in
		*"BUILD FAILURE"*) BUILD_RESULT=-1 ;;
		*) BUILD_RESULT=0 ;;
	esac
	if [ "$BUILD_RESULT" = "-1" ]
	then
		echo "error building plugins"
		exit -1
	fi
	cd $CURR
}

function copyPluginsFromDistribution {
    echo "copy plugins"
	cp $DEPLOYIT_HOME/deployit-$DEPLOYIT_VERSION-server/available-plugins/*jar $DEPLOYIT_HOME/deployit-3.8.4-server/plugins
	find $ROOTDIR/lib/ -name *jar -exec cp {} $DEPLOYIT_HOME/deployit-$DEPLOYIT_VERSION-server/plugins \;
}

function validate {
	echo "validate"
	cd $DEPLOYIT_HOME
	rm -f nohup.out
	nohup ./deployit-$DEPLOYIT_VERSION-server/bin/server.sh > nohup.out &
    CONTINUE=0
    COUNT=12
    SLEEP_TIME=5
	echo "Starting Deployit, waiting $COUNT times $SLEEP_TIME seconds"
    printf "waiting,"
    while [ "$CONTINUE" = "0" ]
    do
        COUNT=`expr $COUNT - 1`
        printf " $COUNT "
	    sleep $SLEEP_TIME
        RUN_RESULT=`grep "You can now point your browser to" nohup.out`
        len=${#RUN_RESULT}
        if [[ "$len" -gt 0 || "$COUNT" -eq 0 ]]
        then
            CONTINUE=-1
        fi
    done
    echo

	if [[ "${#RUN_RESULT}" -eq 0 ]]
	then
		echo "error starting deployit"
		exit -1
	fi
	echo "ok"
}

parseopts $*
printEnv
findAndTerminateDeployitProces
installDeployit
copyPluginsFromDistribution
buildAndCopyPlugins
validate