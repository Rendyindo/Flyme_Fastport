#!/bin/sh

#######################################
####################
# Flyme OS Fastport
#    by RendyAK
####################
#######################################
# Usage:
# . port.sh --force -bn [base boot.img name] [port boot.img name]

# Setting up commands
grep_prop() {
  REGEX="s/^$1=//p"
  shift
  FILES=$@
  if [ -z "$FILES" ]; then
    FILES='$PWD/$2/zip/system/build.prop'
  fi
  cat $FILES 2>/dev/null | sed -n $REGEX | head -n 1
}

grep_setting() {
  REGEX="s/^$1=//p"
  shift
  FILES=$@
  if [ -z "$FILES" ]; then
    FILES='$PWD/setting.prop'
  fi
  cat $FILES 2>/dev/null | sed -n $REGEX | head -n 1
}

revert(){
  echo "- Reverting..."
  rm -rf $PWD/port/zip
  rm -rf $PWD/base/zip
  exit
}

# Main script
echo "Flyme OS Fastport"
echo ""
echo "- Checking files..."
if [ ! -f '$BASEZIP' ]; then
 echo "Cannot find base zip file!"
 echo "Aborting..."
 exit
fi
if [ ! -f '$PORTZIP' ]; then
 echo "Cannot find port zip file!"
 echo "Aborting..."
 exit
fi

echo "- Unzipping base zip..."
unzip $BASEZIP $PWD/base/zip

echo "- Unzipping port zip..."
unzip $PORTZIP $PWD/port/zip

echo "- Checking whether crossport/same chipset port.."
export BASECHPST=$(grep_prop ro.product.board base)
PORTCHPST=$(grep_prop ro.product.board port)
if [ "$BASECHPST" = "$PORTCHPST"]; then
 echo "- Same chipset port detected"
 echo "  Chipset: $BASECHPST"
 PORTPREFIX=SAMEPORT
else
 echo "- Crossport detected"
 echo "  From: $PORTCHPST"
 echo "  To  : $BASECHPST"
 PORTPREFIX=CROSSPORT
fi

if [ "$PORTPREFIX" = "SAMEPORT" ];then
 if [ ! "$BASECHPST" = "mt6580" ]; then
 elif [ ! "$BASECHPST" = "MT6580" ]; then
 elif [ ! "$2" = "--force" ]; then
 echo "Same chipset port only works on mt6580 chipset!"
 echo "Please send me some info for other chipset same chipset tutorial if you want your chipset supported"
 echo "Or, if you still want to try, use --force to continue"
 revert
 fi
fi

if [ "$PORTPREFIX" = "SAMEPORT" ]; then
 . porting/sameport.sh $3 $4 $5
fi

if [ "$PORTPREFIX" = "CROSSPORT" ]; then
 . porting/crossport.sh $3 $4 $5
fi