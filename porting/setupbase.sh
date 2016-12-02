#!/bin/sh

checkdevice(){
 echo ">> Waiting for device"
 DEVICE=$(adb devices)
 if [ "$DEVICE" = "" ]; then
 checkdevice
 else
 echo "<< Device detected"
}

echo ">> Mounting system partition"
adb shell "mount -o remount,rw /system"
echo "<< Mounting system partition"

echo ""
echo ">> Getting system files"
adb pull /system system
echo "<< Getting system files"

echo ""
echo ">>> Getting boot image"
adb shell

if [ -f "/dev/block/platform/*/by-name/boot" ]; then
BOOTPATH=$(ls /dev/block/platform/*/by-name/boot)
fi

if [ -f "/dev/block/platform/*/*/by-name/boot" ]; then
BOOTPATH=$(ls /dev/block/platform/*/*/by-name/boot)
fi
readlink -f $BOOTPATH > /sdcard/BOOTPATH

exit

adb pull /sdcard/BOOTPATH BOOTPATH
BOOTPATH=$(cat BOOTPATH)

echo "Boot image path: $BOOTPATH"
adb pull $BOOTPATH boot.img
echo "<< Getting boot image"
echo ">> Zipping system and boot"
zip -q -r -y fullota.zip *
echo "<< Zipping system and boot"
