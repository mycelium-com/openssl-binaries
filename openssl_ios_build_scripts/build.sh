#!/bin/bash

LIB_NAME="openssl-1.1.1d"

PLATFORMPATH="/Applications/Xcode.app/Contents/Developer/Platforms"
TOOLSPATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export IPHONEOS_DEPLOYMENT_TARGET="10.0"

ROOT=$(pwd)

findLatestSDKVersion()
{
    sdks=`ls $PLATFORMPATH/$1.platform/Developer/SDKs`
    arr=()
    for sdk in $sdks
    do
       arr[${#arr[@]}]=$sdk
    done

    # Last item will be the current SDK, since it is alpha ordered
    count=${#arr[@]}
    if [ $count -gt 0 ]; then
       sdk=${arr[$count-1]:${#1}}
       num=`expr ${#sdk}-4`
       SDKVERSION=${sdk:0:$num}
    else
       SDKVERSION="10.0"
    fi
}

findLatestSDKVersion iPhoneOS

function get_build_platform() {
  local arch=$1
  case ${arch} in
  ios-arm64)
    echo "iPhoneOS"
    ;;
  ios-arm64-simulator|ios-x86_64-simulator)
    echo "iPhoneSimulator"
    ;;
  esac
}

function get_build_cpu() {
  local arch=$1
  case ${arch} in
  ios-arm64|ios-arm64-simulator)
    echo "arm64"
    ;;
  ios-x86_64-simulator)
    echo "x86_64"
    ;;
  esac
}

function get_build_target() {
  local arch=$1
  case ${arch} in
  ios-arm64|ios-arm64-simulator)
    echo "arm-apple-darwin10"
    ;;
  ios-x86_64-simulator)
    echo "x86_64-apple-darwin10"
    ;;
  esac
}

function get_sdk_type() {
  local arch=$1
  case ${arch} in
  ios-arm64)
    echo "iphoneos"
    ;;
  ios-arm64-simulator|ios-x86_64-simulator)
    echo "iphonesimulator"
    ;;
  esac
}

function get_ossl_target_type() {
  local arch=$1
  case ${arch} in
  ios-arm64)
    echo "ios64-xcrun"
    ;;
  ios-arm64-simulator|ios-x86_64-simulator)
    echo "iossimulator-xcrun"
    ;;
  esac
}


if [ ! -s "$ROOT/${LIB_NAME}.tar.gz" ]; then 
    echo "Downloading ${LIB_NAME}.tar.gz"
    curl https://www.openssl.org/source/${LIB_NAME}.tar.gz >$ROOT/${LIB_NAME}.tar.gz
fi

ROOT=$(pwd)

if [ ! -d $ROOT/${LIB_NAME} ]
then
    tar -xzf $ROOT/${LIB_NAME}.tar.gz
fi

# All targets are processed separately
for build_os in ios-arm64 ios-arm64-simulator ios-x86_64-simulator
do
    platform=$(get_build_platform $build_os)
    cpu=$(get_build_cpu $build_os)
    sdk_type=$(get_sdk_type $build_os)
    ossl_target=$(get_ossl_target_type $build_os)

    # Setup build utilities info
    export CC="$(xcrun -sdk $sdk_type -find clang)"
    export CXX="$(xcrun -sdk $sdk_type -find clang++)"
    export CPP="$CC -E"
    export CFLAGS="-arch $cpu -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk -m${sdk_type}-version-min=12.0 -Wno-error=implicit-function-declaration -fembed-bitcode"
    export CPPFLAGS=$CFLAGS
    export CXXFLAGS="-arch $cpu -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk -m${sdk_type}-version-min=12.0 -no-cpp-precomp -stdlib=libc++ -DHAVE_CXX_STDHEADERS -fembed-bitcode"
    export AR=$(xcrun -sdk $sdk_type -find ar)
    export LIBTOOL=$(xcrun -sdk $sdk_type -find libtool)
    export NM=$(xcrun -sdk $sdk_type -find nm)
    export OTOOL=$(xcrun -sdk $sdk_type -find otool)
    export RANLIB=$(xcrun -sdk $sdk_type -find ranlib)
    export STRIP=$(xcrun -sdk $sdk_type -find strip)
    export LDFLAGS="-arch $cpu -fembed-bitcode -isysroot $PLATFORMPATH/$platform.platform/Developer/SDKs/$platform$SDKVERSION.sdk"
    
    target_dir=$ROOT/output/$build_os

    rm -rf $target_dir
    mkdir -p $target_dir

    cd $ROOT/${LIB_NAME}
    
    # Remove previous configuration
    make clean 2> /dev/null
    make distclean 2> /dev/null

    echo "Configuring for $build_os..."
    ./Configure $ossl_target "-arch $cpu -fembed-bitcode" no-asm no-shared no-hw no-async --prefix=$target_dir

    echo "Compiling for $build_os..."
    make -j $(sysctl -n hw.physicalcpu)
    make install 2> /dev/null
    echo Done

    cd $ROOT
done

# Removing sources
rm -rf $ROOT/${LIB_NAME}

