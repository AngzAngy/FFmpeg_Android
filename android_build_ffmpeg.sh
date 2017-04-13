export NDK=/home/kuwo/devtools/android-ndk-r13
export PLATFORMS=android-21

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
    --cross-prefix=$TOOLCHAINS \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS -I./external/x264libs/$EABI/include -I./external/faaclibs/include" \
    --extra-ldflags="$ADDI_LDFLAGS -L./external/x264libs/$EABI/lib -L./external/faaclibs/$EABI" \
    $ADDITIONAL_CONFIGURE_FLAG $OPTIM

make clean
make -j4
make install
make distclean
echo "install--> `pwd`/android/$EABI" 
}

##armeabi
ARCH=arm
EABI=armeabi
SYSROOT=$NDK/platforms/$PLATFORMS/arch-arm/
TOOLCHAINS=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
OPTIMIZE_CFLAGS="-marm"
ADDITIONAL_CONFIGURE_FLAG=--disable-neon
build_one

##armeabi-v7a
ARCH=arm
EABI=armeabi-v7a
SYSROOT=$NDK/platforms/$PLATFORMS/arch-arm/
TOOLCHAINS=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
OPTIMIZE_CFLAGS="-O3 -mfloat-abi=softfp -mfpu=neon -marm -march=armv7-a -mtune=cortex-a8"
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one

##arm64-v8a
ARCH=arm
EABI=arm64-v8a
SYSROOT=$NDK/platforms/$PLATFORMS/arch-arm64/
TOOLCHAINS=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
OPTIMIZE_CFLAGS="-march=armv8-a -D__ANDROID__ -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__"
ADDITIONAL_CONFIGURE_FLAG=--disable-neon
OPTIM=--disable-asm # must disable asm optimized in 64 arch
build_one

##x86
ARCH=x86
EABI=x86
SYSROOT=$NDK/platforms/$PLATFORMS/arch-x86/
TOOLCHAINS=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64/bin/i686-linux-android-
OPTIMIZE_CFLAGS="-march=i686 -mtune=i686 -m32 -mmmx -msse2 -msse3 -mssse3 -D__ANDROID__ -D__i686__"
ADDITIONAL_CONFIGURE_FLAG=--disable-neon
OPTIM=--disable-asm # must disable asm optimized in x86 arch
build_one

##x86_64
ARCH=x86
EABI=x86_64
SYSROOT=$NDK/platforms/$PLATFORMS/arch-x86_64/
TOOLCHAINS=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64/bin/x86_64-linux-android-
OPTIMIZE_CFLAGS="-march=core-avx-i -mtune=core-avx-i -m64 -mmmx -msse2 -msse3 -mssse3 -msse4.1 -msse4.2 -mpopcnt -D__ANDROID__ -D__x86_64__"
ADDITIONAL_CONFIGURE_FLAG=--disable-neon
OPTIM=--disable-asm # must disable asm optimized in x86_64 arch
build_one
