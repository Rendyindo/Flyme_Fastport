#!/bin/sh
# Bug fixing

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
 mv port/zip/system/framework/framework-res/res/xml/storage_list.xml base/zip/system/framework/framework-res/res/xml/storage_list.xml
 echo "- Building framework-res.apk..."
 . tool/apktool.sh b $PWD/port/zip/system/franework/framework-res
 echo "- Cleaning up"
 rm -rf $PWD/port/zip/system/franework/framework-res
 rm -rf $PWD/base/zip/system/franework/framework-res
}