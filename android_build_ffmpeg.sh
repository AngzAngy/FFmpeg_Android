export NDK=/home/angzangy/android-ndk-r13b

ARCH=
EABI=
SYSROOT=
ROSSPREFIX=
EXTRA_CFLAGS=
EXTRA_LDFLAGS=
ADDITIONAL_CONFIGURE_FLAG=

function build_one
{
./configure \
    --prefix=./android/$EABI \
    --disable-shared \
    --enable-static \
    --enable-libx264 \
    --enable-libfdk-aac \
    --enable-nonfree \
    --enable-gpl \
    --enable-encoder=libx264 \
    --enable-encoder=libfdk-aac \
    --enable-jni \
    --enable-mediacodec \
    --enable-hwaccel=h264_mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-encoder=h264_mediacodec \
    --enable-runtime-cpudetect \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --target-os=android \
    --sysroot=$SYSROOT \
    --arch=$ARCH \
    --enable-cross-compile \
    --cross-prefix=$ROSSPREFIX \
    --extra-cflags="-Os -fPIC $EXTRA_CFLAGS -I`pwd`/external/x264libs/$EABI/include -I`pwd`/external/fdk-aaclibs/$EABI/include" \
    --extra-ldflags="$EXTRA_LDFLAGS -L./external/x264libs/$EABI/lib -L./external/fdk-aaclibs/$EABI/lib" \
    $ADDITIONAL_CONFIGURE_FLAG 

make clean
make -j4
make install
make distclean
echo "install--> `pwd`/android/$EABI" 
}

BUILD_ARCH=$1

if [ -z "$BUILD_ARCH" ]; then
    echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
    echo ""
    exit 1
fi

if [ "$BUILD_ARCH" = "armv7a" ]; then
	ARCH=arm
	EABI=armeabi-v7a
        ROSSPREFIX=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
	SYSROOT=$NDK/platforms/android-21/arch-arm
	EXTRA_CFLAGS="-mfpu=vfp -mfloat-abi=softfp"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=armv7-a --disable-neon"
elif [ "$BUILD_ARCH" = "armv5" ]; then
	ARCH=arm
	EABI=armeabi
        ROSSPREFIX=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
	SYSROOT=$NDK/platforms/android-21/arch-arm
	EXTRA_CFLAGS="-march=armv5te -msoft-float"
	ADDITIONAL_CONFIGURE_FLAG="--disable-neon"
elif [ "$BUILD_ARCH" = "armv7aneon" ]; then
	ARCH=arm
	EABI=armeabi-v7a-neon
	CPU=armv7-a
        ROSSPREFIX=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
	SYSROOT=$NDK/platforms/android-21/arch-arm
	EXTRA_CFLAGS="-mfpu=neon -mfloat-abi=softfp"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=armv7-a --enable-neon --disable-asm"
elif [ "$BUILD_ARCH" = "arm64" ]; then
	ARCH=arm64
	EABI=arm64-v8a
        ROSSPREFIX=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
	SYSROOT=$NDK/platforms/android-21/arch-arm64
elif [ "$BUILD_ARCH" = "x86" ]; then
	ARCH=x86
	EABI=x86
        ROSSPREFIX=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64/bin/i686-linux-android-
	SYSROOT=$NDK/platforms/android-21/arch-x86
	EXTRA_CFLAGS="-msse3 -ffast-math -mfpmath=sse"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=i686 --disable-yasm"
elif [ "$BUILD_ARCH" = "x86_64" ]; then
	ARCH=x86_64
	EABI=x86_64
        ROSSPREFIX=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64/bin/x86_64-linux-android-
	SYSROOT=$NDK/platforms/android-21/arch-x86_64
	ADDITIONAL_CONFIGURE_FLAG="--cpu=x86_64 --disable-yasm"
else
	echo "unknow architechure $BUILD_ARCH"
        echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
	exit 1
fi

build_one
