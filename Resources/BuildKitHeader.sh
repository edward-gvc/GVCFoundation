#!/bin/sh

#  BuildKitHeader.sh
#  GVCFoundation
#
#  Created by David Aspinall on 11-10-02.
#  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.


printHeader()
{
    echo "/**"
    echo " * Header for $1"
    echo " * Date: " `date`
    echo " * Author:" $USER
    echo " */" 
	echo
	echo "#ifndef $1_h"
	echo "#define $1_h"
	echo
}


printFooter()
{
	echo
	echo "#endif // $1_h"

}

(
	printHeader $PRODUCT_NAME

    SEDS="s/^$PRODUCT_NAME\///"
    find $PRODUCT_NAME -name \*.h ! -name $PRODUCT_NAME.h | \
        sed "$SEDS" | sort | \
        awk 'BEGIN {FS="/"} \
            { F=$NF; $NF=""; if ( BASE"" != $0 ) { printf "\n/* \n * %s\n */\n", $0; BASE=$0 } } \
            { printf "#import \"%s\"\n", F}' 

    printFooter $PRODUCT_NAME
) > $PRODUCT_NAME/$PRODUCT_NAME.h



