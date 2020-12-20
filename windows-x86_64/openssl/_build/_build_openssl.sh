#!/bin/bash

export OPENSSL_SRC="..";

export SYSROOT="$ANDROID_NDK_HOME/sysroot"

export CC=clang
export API_LEVEL=23

export BASE_DESTDIR=_build

export INCLUDES_DESTDIR="$BASE_DESTDIR/include"
export LIBS_BASE_DESTDIR="$BASE_DESTDIR/libs"

pushd "$OPENSSL_SRC";

BUILD_TARGETS="armeabi-v7a arm64-v8a x86 x86_64"
#BUILD_TARGETS="x86_64"

for build_target in $BUILD_TARGETS
do
    case $build_target in
    armeabi)
        TRIBLE="arm-linux-androideabi"
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}"
		LIBS_DESTDIR="$LIBS_BASE_DESTDIR/armeabi"
        SSL_TARGET="android-arm"
    ;;
    armeabi-v7a)
        TRIBLE="arm-linux-androideabi"
        OPTIONS="--target=armv7a-linux-androideabi -Wl,--fix-cortex-a8 -fPIC -static -D__ANDROID_API__=${API_LEVEL}"
		LIBS_DESTDIR="$LIBS_BASE_DESTDIR/armeabi-v7a"
        SSL_TARGET="android-arm"
    ;;
    x86)
        TRIBLE="i686-linux-android"
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}"
		LIBS_DESTDIR="$LIBS_BASE_DESTDIR/x86"
        SSL_TARGET="android-x86"
    ;;
    x86_64)
        TRIBLE="x86_64-linux-android"
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}"
		LIBS_DESTDIR="$LIBS_BASE_DESTDIR/x86_64"
        SSL_TARGET="android-x86_64"
    ;;
    arm64-v8a)
        TRIBLE="aarch64-linux-android"
        OPTIONS="-fPIC -static -D__ANDROID_API__=${API_LEVEL}"
		LIBS_DESTDIR="$LIBS_BASE_DESTDIR/arm64-v8a"
        SSL_TARGET="android-arm64"
    ;;
    esac

	rm -rf "$LIBS_DESTDIR";
   	mkdir -p "$LIBS_DESTDIR";

	make clean;
    	perl ./Configure $SSL_TARGET $OPTIONS \
			-I"$SYSROOT/usr/include" \
			-I"$SYSROOT/usr/include/$TRIBLE" \
			no-asm \
			no-shared \
			no-hw \
			no-sse2 \
			no-unit-test && \
	make;

	cp -R ./libcrypto.a $LIBS_DESTDIR;
	cp -R ./libssl.a  $LIBS_DESTDIR;
done

rm -rf "$INCLUDES_DESTDIR";
mkdir -p "$INCLUDES_DESTDIR";

cp -R ./include/* "$INCLUDES_DESTDIR";

popd;

exit 0;
