export NDK=/home/angzangy/android-ndk-r13b

function build_aac
{
./autogen.sh
./configure --prefix=$PREFIX \
            --host=$HOST

make clean
make -j4
make install
}

BUILD_ARCH=$1

if [ -z "$BUILD_ARCH" ]; then
    echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
    echo ""
    exit 1
fi

if [ "$BUILD_ARCH" = "armv7a" ]; then
        TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-arm

	export CC="$TOOLCHAIN/bin/arm-linux-androideabi-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/arm-linux-androideabi-g++ --sysroot=$SYSROOT"
	export CFLAGS="-mfpu=vfp -mfloat-abi=softfp"
	export CXXFLAGS="$CFLAGS"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi-v7a

	echo "start---------------------------->"
	echo $PATH
elif [ "$BUILD_ARCH" = "armv5" ]; then
        TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-arm

	export CC="$TOOLCHAIN/bin/arm-linux-androideabi-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/arm-linux-androideabi-g++ --sysroot=$SYSROOT"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi
elif [ "$BUILD_ARCH" = "armv7aneon" ]; then
        TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-arm

	export CC="$TOOLCHAIN/bin/arm-linux-androideabi-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/arm-linux-androideabi-g++ --sysroot=$SYSROOT"
	export CFLAGS="-mfpu=neon -mfloat-abi=softfp"
	export CXXFLAGS="$CFLAGS"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi-v7a-neon
elif [ "$BUILD_ARCH" = "arm64" ]; then
	TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-arm64

	export CC="$TOOLCHAIN/bin/aarch64-linux-android-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/aarch64-linux-android-g++ --sysroot=$SYSROOT"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=aarch64-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/arm64-v8a
elif [ "$BUILD_ARCH" = "x86" ]; then
	TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-x86

	export CC="$TOOLCHAIN/bin/i686-linux-android-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/i686-linux-android-g++ --sysroot=$SYSROOT"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=i686-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/x86
elif [ "$BUILD_ARCH" = "x86_64" ]; then
	TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64
        SYSROOT=$NDK/platforms/android-21/arch-x86_64

	export CC="$TOOLCHAIN/bin/x86_64-linux-android-gcc --sysroot=$SYSROOT"
	export CXX="$TOOLCHAIN/bin/x86_64-linux-android-g++ --sysroot=$SYSROOT"
	export LDFLAGS="-L$SYSROOT/usr/lib"

	HOST=x86_64-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/x86_64
else
	echo "unknow architechure $BUILD_ARCH"
        echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
	exit 1
fi

###  add PATH env is important  ###
export PATH=$PATH:$TOOLCHAIN/bin

build_aac
