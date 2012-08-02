#!/bin/sh

# Arguments are sed(1) transform command
# First argument - transformation of old name
# Second argument - transformation of new name
TRANSFORM_COMMAND_OLD_NAME="$1"
[ -z "$TRANSFORM_COMMAND_OLD_NAME" ] && TRANSFORM_COMMAND_OLD_NAME="n"

TRANSFORM_COMMAND_NEW_NAME="$2"
[ -z "$TRANSFORM_COMMAND_NEW_NAME" ] && TRANSFORM_COMMAND_NEW_NAME="n"


while read symbolname; do
	oldsymbolname=`echo "$symbolname" | sed -e "$TRANSFORM_COMMAND_OLD_NAME"`
	newsymbolname=`echo "$symbolname" | sed -e "$TRANSFORM_COMMAND_NEW_NAME"`
	echo -n " --redefine-sym $oldsymbolname=$newsymbolname"
done
echo
