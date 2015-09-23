export NDK=/home/angzangy/android-ndk-r10d
SYSROOT=$NDK/platforms/android-9/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64

function build_one
{
./configure \
    --prefix=$PREFIX \
    --disable-shared \
    --enable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
 
make clean
make  -j4 install
}

#CPU=arm
#PREFIX=$(pwd)/android/$CPU 
#OPTIMIZE_CFLAGS="-marm"
#build_one

#arm v7n
CPU=armv7-a
OPTIMIZE_CFLAGS="-O3 -mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
PREFIX=$(pwd)/android/${CPU}_neon
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one
