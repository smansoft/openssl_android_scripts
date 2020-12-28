#!/bin/bash

OPENSSL_SRC="..";

BUILD_DIR="./_build";
BASE_DESTDIR=".";

export SYSROOT="$ANDROID_NDK_HOME/sysroot";

export CC=clang;
export API_LEVEL=23;

CURR_DIR=$(pwd);

OPENSSL_SRC_A="$CURR_DIR/$OPENSSL_SRC";
BUILD_DIR_A="$CURR_DIR/$BUILD_DIR";
BASE_DESTDIR_A="$CURR_DIR/$BASE_DESTDIR";

if [ ! -d $BUILD_DIR_A ]; then
    mkdir $BUILD_DIR_A;
fi;

if [ ! -d $BASE_DESTDIR_A ]; then
    mkdir $BASE_DESTDIR_A;
fi;

INCLUDES_DESTDIR_A="$BASE_DESTDIR_A/include";
LIBS_BASE_DESTDIR_A="$BASE_DESTDIR_A/libs";

BUILD_TARGETS="armeabi-v7a arm64-v8a x86 x86_64";
#BUILD_TARGETS="x86_64";

for build_target in $BUILD_TARGETS
do
    case $build_target in
    armeabi)
        TRIBLE="arm-linux-androideabi";
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}";
        LIBS_DESTDIR_A="$LIBS_BASE_DESTDIR_A/armeabi";
        SSL_TARGET="android-arm";
    ;;
    armeabi-v7a)
        TRIBLE="arm-linux-androideabi";
        OPTIONS="--target=armv7a-linux-androideabi -Wl,--fix-cortex-a8 -fPIC -static -D__ANDROID_API__=${API_LEVEL}";
        LIBS_DESTDIR_A="$LIBS_BASE_DESTDIR_A/armeabi-v7a";
        SSL_TARGET="android-arm";
    ;;
    x86)
        TRIBLE="i686-linux-android";
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}";
        LIBS_DESTDIR_A="$LIBS_BASE_DESTDIR_A/x86";
        SSL_TARGET="android-x86";
    ;;
    x86_64)
        TRIBLE="x86_64-linux-android";
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}";
        LIBS_DESTDIR_A="$LIBS_BASE_DESTDIR_A/x86_64";
        SSL_TARGET="android-x86_64";
    ;;
    arm64-v8a)
        TRIBLE="aarch64-linux-android";
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}";
        LIBS_DESTDIR_A="$LIBS_BASE_DESTDIR_A/arm64-v8a";
       SSL_TARGET="android-arm64";
    ;;
    esac

	if [ -d "$BUILD_DIR_A" ]; then
	    rm -rf "$BUILD_DIR_A";
	fi;
        mkdir "$BUILD_DIR_A";

	pushd "$BUILD_DIR_A";

	perl $OPENSSL_SRC_A/Configure $SSL_TARGET $OPTIONS \
			-I"$SYSROOT/usr/include" \
			-I"$SYSROOT/usr/include/$TRIBLE" \
			no-asm \
			no-shared \
			no-hw \
			no-sse2 \
			no-unit-test && \
	make clean;
	make;

	if [ -d "$LIBS_DESTDIR_A" ]; then
	    rm -rf "$LIBS_DESTDIR_A";
	fi;
	mkdir -p "$LIBS_DESTDIR_A";

	cp -R $BUILD_DIR_A/libcrypto.a $LIBS_DESTDIR_A;
	cp -R $BUILD_DIR_A/libssl.a  $LIBS_DESTDIR_A;

	popd;
done;

if [ -d "$INCLUDES_DESTDIR_A" ]; then
    rm -rf "$INCLUDES_DESTDIR_A";
fi;
mkdir -p "$INCLUDES_DESTDIR_A";

cp -R $OPENSSL_SRC_A/include/* "$INCLUDES_DESTDIR_A";

exit 0;
