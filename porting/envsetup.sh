#!/bin/sh
# Variable Setup
# Usage:
# . porting/envsetup.sh [-p [Product Codename] ] [ -c [Chipset] ]

checkforhome(){
if [ -f '$PWD/port.sh' ]; then
 export PORT_HOME=$PWD
else
 cd ..
 checkforhome
fi
}

if [ $2 = "-p" ]; then
 export PORT_PRODUCT=$3
fi

grep_prop() {
  REGEX="s/^$1=//p"
  shift
  FILES=$@
  if [ -z "$FILES" ]; then
    FILES='$PWD/$2/zip/system/build.prop'
  fi
  cat $FILES 2>/dev/null | sed -n $REGEX | head -n 1
}

export PORT_ANDROID_SDK=$(grep_prop ro.build.version.sdk base)
case $PORT_ANDROID_SDK in
 23) export PORT_ANDROID_VERSION="6.0.x Marshmallow";;
 22) export PORT_ANDROID_VERSION="5.1 Lollipop";;
 21) export PORT_ANDROID_VERSION="5.0 Lollipop";;
 *) echo "Sorry, I didn't test for Android Kitkat and below"; exit;;
esac

export BASECHPST=$(grep_prop ro.product.board base)

if [ "$2" = "-c" ]; then
 export BASECHPST=$3
fi

if [ "$4" = "-c" ]; then
 export BASECHPST=$4
fi

echo "PORT_HOME              = $PORT_HOME"
echo "PORT_PRODUCT           = $PORT_PRODUCT"
echo "PORT_ANDROID_SDK       = $PORT_ANDROID_SDK"
echo "PORT_ANDROID_VERSION   = $PORT_ANDROID_VERSION"
echo "BASECHPST              = $BASECHPST"
exit