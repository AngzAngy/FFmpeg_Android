/home/kuwo/devtools/android-ndk-r13/build/tools/make-standalone-toolchain.sh --toolchain=arm-linux-androideabi-4.9 --stl=gnustl --arch=arm --platform=android-9 --install-dir=$HOME/my-android-toolchain-arm
export PATH=$HOME/my-android-toolchain-arm/bin:$PATH
export CC=arm-linux-androideabi-gcc
export CXX=arm-linux-androideabi-g++
export CXXFLAGS="-lstdc++"
autoconf
automake -a
./configure --prefix=/home/kuwo/source/FFmpeg_Android/FFmpeg-release-2.6/external/faaclibs/armeabi-v7a  --host=x86_64-linux-gnu
make && make install
