#! /bin/sh

SAVIFS=$IFS
IFS=$(echo -en "\n\b")

# wont print error in for loop if there are no avi files in the directory
shopt -s nullglob

cd `dirname $0`

ROOT=~/Library/Developer/Xcode/Templates

if [ ! -d "$ROOT" ]; then
	echo "Base directory not found [$ROOT]"
	exit
fi

echo "Synchronizing $ROOT/GVC Foundation"

rsync --update --verbose --recursive --delete "GVC Foundation" "$ROOT/"

