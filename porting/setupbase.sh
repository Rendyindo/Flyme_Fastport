#!/bin/sh
# Set up base zip

echo "- Pulling boot image.."
if [ -f "/dev/block/platform/*/*/by-name/boot" ]; then
 export BOOTPARTITION=$(readlink -f /dev/block/platform/*/*/by-name/boot)
fi
if [ -f "/dev/block/platform/*/by-name/boot" ]; then
 export BOOTPARTITION=$(readlink -f /dev/block/platform/*/*/by-name/boot)
fi
if [ "$BOOTPARTITION" = "" ]; then
 echo "Couldn't find Boot Partition!"
 echo "use 'export BOOTPARTITION=[partition path]' "
 echo "And then rerun this script!"
fi

adb pull $BOOTPARTITION $PORT_HOME/base/boot.img

echo "- Pulling system.."

adb pull /system $PORT_HOME/base/system

echo "- Zipping.."

cd $PORT_HOME/base
zip -q -r -y stockrom.zip *

echo "- Done!"

cd $PORT_HOME