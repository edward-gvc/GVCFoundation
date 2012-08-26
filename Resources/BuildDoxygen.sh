#! /bin/sh

SCRIPT_ROOT=`dirname $0`
abspath() {
	ABSPATH=`cd \`dirname "${1}"\`; pwd`"/"`basename "${1}"`
	echo $ABSPATH
}

# Build the doxygen documentation for the project and load the docset into Xcode.

# Use the following to adjust the value of the $DOXYGEN_PATH
# Binary install location: /Applications/Doxygen.app/Contents/Resources/doxygen
DOXYGEN_PATH=/Applications/Doxygen.app/Contents/Resources/doxygen
if [ ! -x $DOXYGEN_PATH ]; then
	# Source build install location: /usr/local/bin/doxygen
	DOXYGEN_PATH=/usr/local/bin/doxygen
	if [ ! -x $DOXYGEN_PATH]; then
		echo "Unable to locate doxygen command line binary"
		exit 1
	fi
fi

CONFIG_PATH=$SCRIPT_ROOT/doxygen.config
# If the config file doesn’t exist, run ‘doxygen -g $SOURCE_ROOT/doxygen.config’ to
# a get default file.
if ! [ -f $CONFIG_PATH ]
then
	echo "doxygen config file does not exist at $CONFIG_PATH .. creating"
	$DOXYGEN_PATH -g $CONFIG_PATH
fi

# Append the proper input/output directories and docset info to the config file.
# This works even though values are assigned higher up in the file. Easier than sed.
SRC_ROOT=`abspath ${SCRIPT_ROOT}/../GVCFoundation`
OUT_ROOT=$TMPDIR/GVCFoundation
TEMP_CONFIG=$OUT_ROOT/doxygen.config

echo "Clearing $OUT_ROOT"
if [ -d $OUT_ROOT ]; then
	rm -Rf $OUT_ROOT/html
else
	mkdir $OUT_ROOT
fi

cp $CONFIG_PATH $TEMP_CONFIG

echo "INPUT = $SRC_ROOT" >> $TEMP_CONFIG
echo "OUTPUT_DIRECTORY = $OUT_ROOT" >> $TEMP_CONFIG
echo "PROJECT_NUMBER = `date \"+%Y-%m-%d\"`" >> $TEMP_CONFIG

# Run doxygen on the updated config file.
# Note: doxygen creates a Makefile that does most of the heavy lifting.
$DOXYGEN_PATH $TEMP_CONFIG 1>/dev/null

# make will invoke docsetutil. Take a look at the Makefile to see how this is done.
make -C $OUT_ROOT/html install  1>/dev/null

# Construct a temporary applescript file to tell Xcode to load a docset.

rm -f $TMPDIR/loadDocSet.scpt

echo "tell application \"Xcode\"" >> $TMPDIR/loadDocSet.scpt
echo "load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/net.global-village.GVCFoundation.docset\""
>> $TMPDIR/loadDocSet.scpt
echo "end tell" >> $TMPDIR/loadDocSet.scpt

# Run the load-docset applescript command.

osascript $TMPDIR/loadDocSet.scpt

exit 0
