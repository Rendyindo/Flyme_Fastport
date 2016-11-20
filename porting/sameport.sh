#!/bin/sh
# Flyme-Fastport/porting/sameport.sh
# Same Chipset porting shell script

revert(){
  echo "- Reverting..."
  rm -rf $PWD/port/zip
  rm -rf $PWD/base/zip
  exit
}

if [ "$2" = "-bn" ]; then
 BOOTBASENAME=$3
 BOOTPORTNAME=$4
fi

echo "- Same Chipset Port -"
echo "- Unpacking base boot.img.."
if [ ! -f '$PWD/base/zip/boot.img' ]; then
elif [ ! -f '$PWD/base/zip/$3' ]; then
 echo "Base boot image cannot be found!"
 echo "Aborting..."
 echo "Note: If the boot image name is not specified, use -bn to specify the boot name"
 revert
fi

mv $PWD/base/zip/$3 $PWD/tool/unpackboot/boot.img
. tool/unpackboot/unpackimg.sh boot.img
mkdir $PWD/base/zip/boot
mv -rf $PWD/tool/unpackboot/split_img $PWD/base/zip/boot/split_img
mv -rf $PWD/tool/unpackboot/ramdisk $PWD/base/zip/boot/ramdisk

echo "- Unpacking port boot.img.."
if [ ! -f '$PWD/port/zip/boot.img' ]; then
elif [ ! -f '$PWD/port/zip/$3' ]; then
 echo "Port boot image cannot be found!"
 echo "Aborting..."
 echo "Note: If the boot image name isn't specified, use -bn to specify the boot name"
 revert
fi

mv $PWD/port/zip/$3 $PWD/tool/unpackboot/boot.img
. tool/unpackboot/unpackimg.sh boot.img
mkdir $PWD/port/zip/boot
mv -rf $PWD/tool/unpackboot/split_img $PWD/port/zip/boot/split_img
mv -rf $PWD/tool/unpackboot/ramdisk $PWD/port/zip/boot/ramdisk

echo "- Porting boot.img"

mv $PWD/base/zip/boot/split_img/boot.img-zImage $PWD/port/zip/boot/split_img/boot.img-zImage
mv $PWD/base/zip/boot/ramdisk/fstab.$BASECHPST $PWD/port/zip/boot/ramdisk/fstab.$BASECHPST

. tool/unpackboot/cleanup.sh

mv $PWD/port/zip/boot/split_img $PWD/tool/unpackboot/split_img
mv $PWD/port/zip/boot/ramdisk $PWD/tool/unpackboot/ramdisk

. tool/unpackboot/repacking.sh

mv $PWD/tool/unpackboot/image-new.img $PWD/port/zip/boot.img

echo "- Porting system.."

mv $PWD/base/zip/system/pq $PWD/port/zip/system/pq
mv $PWD/base/zip/system/vold $PWD/port/zip/system/vold

echo "- Cleaning up.."

rm -rf $PWD/port/zip/boot
rm -rf $PWD/port/zip/boot

echo "- Setting up META-INF"
cp $PWD/porting/META-INF $PWD/port/zip/META-INF

echo -e "Please enter your system block path.."
read SYSBLOCKPATH

echo "- Using system block path: $SYSBLOCKPATH"

echo "- Generating updater-script"
echo 'run_program("/sbin/rm/", "-rf", "/system");' >> $PWD/port/zip/META-INF/com/google/android/updater-script
echo 'mount("ext4", "EMMC", "/dev/block/platform/mtk-msdc.0/by-name/system", "/system", "");' >> $PWD/port/zip/META-INF/com/google/android/updater-script
cat $PWD/porting/updater-script >> $PWD/port/zip/META-INF/com/google/android/updater-script

echo -e "Please enter your boot block path.."
read BOOTBLOCKPATH
echo "- Using boot block path: $BOOTBLOCKPATH"
echo 'package_extract_file("boot.img", "$BOOTBLOCKPATH");' >> $PWD/port/zip/META-INF/com/google/android/updater-script



echo "- Zipping"
cd port/zip
zip -q -r -y fullota.zip *
cd ../..
mkdir out
mv port/zip/fullota.zip out/fullota.zip
echo "- Done!"
