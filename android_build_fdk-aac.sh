export NDK=/home/angzangy/android-ndk-r12b
CC_VER=4.9

function make_toolchain
{
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-21 --toolchain=$TOOLCHAIN$CC_VER --install-dir=$TOOLCHAIN_DIR
}

function build_aac
{
./autogen.sh
./configure --prefix=$PREFIX \
            --host=$HOST \
	    LDFLAGS=$LDFLAGS \
            CFLAGS=$CFLAGS \
            CPPFLAGS=$CFLAGS \
            CXXFLAGS=$CFLAGS

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

TOOLCHAIN_DIR=`pwd`/toolchain/$BUILD_ARCH
SYSROOT=$TOOLCHAIN_DIR/sysroot
###  add PATH env is important  ###
export PATH=$PATH:$TOOLCHAIN_DIR/bin

if [ "$BUILD_ARCH" = "armv7a" ]; then
	TOOLCHAIN=arm-linux-androideabi-
	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi-v7a
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
elif [ "$BUILD_ARCH" = "armv5" ]; then
	TOOLCHAIN=arm-linux-androideabi-
	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
elif [ "$BUILD_ARCH" = "armv7aneon" ]; then
	TOOLCHAIN=arm-linux-androideabi-
	HOST=arm-linux-androideabi
	PREFIX=`pwd`/../fdk-aaclibs/armeabi-v7a-neon
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
elif [ "$BUILD_ARCH" = "arm64" ]; then
        TOOLCHAIN=aarch64-linux-android-
	HOST=aarch64-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/arm64-v8a
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
elif [ "$BUILD_ARCH" = "x86" ]; then	
        TOOLCHAIN=x86-
	HOST=i686-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/x86
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
elif [ "$BUILD_ARCH" = "x86_64" ]; then
	TOOLCHAIN=x86_64-
	HOST=x86_64-linux-android
	PREFIX=`pwd`/../fdk-aaclibs/x86_64
	CFLAGS="-I$SYSROOT/usr/include"
	LDFLAGS="-L$SYSROOT/usr/lib"
else
	echo "unknow architechure $BUILD_ARCH"
        echo "You must specific an architecture 'armv5, armv7a, armv7aneon, arm64, x86, x86_64...'."
	exit 1
fi
make_toolchain
build_aac
