export NDK=/home/kuwo/devtools/android-ndk-r13

CC_VER=4.9
ARCH=
EABI=
TOOLCHAIN=
SYSROOT=
ROSSPREFIX=
TOOLCHAIN_DIR=
EXTRA_CFLAGS=
EXTRA_LDFLAGS=
ADDITIONAL_CONFIGURE_FLAG=

function make_toolchain
{
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-21 --toolchain=$TOOLCHAIN$CC_VER --install-dir=$TOOLCHAIN_DIR
}

function build_one
{
./configure \
    --prefix=./android/$EABI \
    --disable-shared \
    --enable-static \
    --enable-libx264 \
    --enable-libfaac \
    --enable-nonfree \
    --enable-gpl \
    --enable-encoder=libx264 \
    --enable-encoder=libfaac\
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --target-os=linux \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --arch=$ARCH \
    --cross-prefix=$ROSSPREFIX \
    --extra-cflags="-Os -fpic $EXTRA_CFLAGS -I./external/x264libs/$EABI/include -I./external/faaclibs/include" \
    --extra-ldflags="$EXTRA_LDFLAGS -L./external/x264libs/$EABI/lib -L./external/faaclibs/$EABI" \
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

TOOLCHAIN_DIR=`pwd`/toolchain/$BUILD_ARCH
SYSROOT=$TOOLCHAIN_DIR/sysroot/

if [ "$BUILD_ARCH" = "armv7a" ]; then
	ARCH=arm
	EABI=armeabi-v7a
        TOOLCHAIN=arm-linux-androideabi-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/$TOOLCHAIN
	EXTRA_CFLAGS="-march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"
        EXTRA_LDFLAGS="-march=armv7-a -Wl,--fix-cortex-a8"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=cortex-a8 --enable-thumb"
elif [ "$BUILD_ARCH" = "armv5" ]; then
	ARCH=arm
	EABI=armeabi
        TOOLCHAIN=arm-linux-androideabi-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/$TOOLCHAIN
	EXTRA_CFLAGS="-march=armv5te -mtune=arm9tdmi -msoft-float"
	ADDITIONAL_CONFIGURE_FLAG="--disable-neon"
elif [ "$BUILD_ARCH" = "armv7aneon" ]; then
	ARCH=arm
	EABI=armeabi-v7a
        TOOLCHAIN=arm-linux-androideabi-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/$TOOLCHAIN
	EXTRA_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb"
        EXTRA_LDFLAGS="-march=armv7-a -Wl,--fix-cortex-a8"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=cortex-a8 --enable-thumb --enable-neon"
elif [ "$BUILD_ARCH" = "arm64" ]; then
	ARCH=arm64
	EABI=arm64-v8a
        TOOLCHAIN=aarch64-linux-android-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/$TOOLCHAIN
	ADDITIONAL_CONFIGURE_FLAG="--enable-thumb"
elif [ "$BUILD_ARCH" = "x86" ]; then
	ARCH=x86
	EABI=x86	
        TOOLCHAIN=x86-linux-android-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/i686-linux-android-
	EXTRA_CFLAGS="-march=atom -msse3 -ffast-math -mfpmath=sse"
	ADDITIONAL_CONFIGURE_FLAG="--cpu=i686 --disable-yasm"
elif [ "$BUILD_ARCH" = "x86_64" ]; then
	ARCH=x86_64
	EABI=x86_64	
	TOOLCHAIN=x86_64-linux-android-
        ROSSPREFIX=$TOOLCHAIN_DIR/bin/$TOOLCHAIN
	ADDITIONAL_CONFIGURE_FLAG="--cpu=x86_64 --disable-yasm"
else
	echo "unknow architechure $BUILD_ARCH"
        echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
	exit 1
fi

make_toolchain
build_one
