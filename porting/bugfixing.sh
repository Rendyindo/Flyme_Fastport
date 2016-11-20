#!/bin/sh
# Bug fixing

warning(){
 echo "Usage:"
 echo ". porting/bugfixing.sh [bug]"
 echo ""
 echo "Bug:"
 echo "camera        : Blank camera fix"
 echo "startingapp   : Stuck at 'Starting apps...'"
}
camerafix(){
 echo "- Copying lib files..."
 mv $PWD/base/zip/system/lib/libcam*.so $PWD/port/zip/system/lib
}

startingappfix(){
 echo "- Decompiling base framework-res.apk..."
 . tool/apktool.sh d $PWD/base/zip/system/franework/framework-res.apk
 echo "- Decompiling port framework-res.apk..."
 . tool/apktool.sh d $PWD/port/zip/system/franework/framework-res.apk
 echo "- Replacing storage_list.xml
 mv port/zip/system/framework/framework-res.out/res/xml/storage_list.xml base/zip/system/framework/framework-res.out/res/xml/storage_list.xml
 echo "- Building framework-res.apk..."
 rm $PWD/port/zip/system/franework/framework-res.apk
 . tool/apktool.sh b $PWD/port/zip/system/franework/framework-res.out -o $PWD/port/zip/system/franework/framework-res.apk
 echo "- Cleaning up"
 rm -rf $PWD/port/zip/system/franework/framework-res.out
 rm -rf $PWD/base/zip/system/franework/framework-res.out
}

if [ "$1" = "" ]; then
 warning
fi
