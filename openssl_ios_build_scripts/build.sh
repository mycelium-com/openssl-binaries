#!/bin/bash

LIB_NAME="openssl-3.0.0"
ROOT=$(pwd)

function get_build_platform() {
  local arch=$1
  case ${arch} in
  ios-arm64)
    echo "iPhoneOS"
    ;;
  ios-arm64-simulator|ios-x86_64-simulator)
    echo "iPhoneSimulator"
    ;;
  macos-arm64|macos-x86_64)
    echo "macOS"
    ;;
  esac
}

function get_build_cpu() {
  local arch=$1
  case ${arch} in
  ios-arm64|ios-arm64-simulator|macos-arm64)
    echo "arm64"
    ;;
  ios-x86_64-simulator|macos-x86_64)
    echo "x86_64"
    ;;
  esac
}

function get_build_target() {
  local arch=$1
  case ${arch} in
  ios-arm64|ios-arm64-simulator|macos-arm64)
    echo "arm-apple-darwin10"
    ;;
  ios-x86_64-simulator|macos-x86_64)
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
  macos-arm64|macos-x86_64)
    echo "macosx"
    ;;
  esac
}

function get_ossl_target_type() {
  local arch=$1
  case ${arch} in
  ios-arm64|ios-arm64-simulator|macos-arm64)
    echo "darwin64-arm64-cc"
    ;;
  ios-x86_64-simulator|macos-x86_64)
    echo "darwin64-x86_64-cc"
    ;;
  esac
}

function get_sdk_path() {
    xcrun -sdk $1 --show-sdk-path
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

function build_for() {
    build_os=$1
    build_type=$2

    platform=$(get_build_platform $build_os)
    cpu=$(get_build_cpu $build_os)
    sdk_type=$(get_sdk_type $build_os)
    sdk_path=$(get_sdk_path $sdk_type)
    ossl_target=$(get_ossl_target_type $build_os)
    optimize_flags="-Og -g"
    
    if [ "${build_type}" = "release" ]; then
        optimize_flags=" -Oz -fno-unroll-loops -ffast-math -flto"
    fi

    # Setup build utilities info
    export CC="$(xcrun -sdk $sdk_type -find clang)"
    export CXX="$(xcrun -sdk $sdk_type -find clang++)"
    export CPP="$CC -E"
    export CFLAGS="-arch $cpu -isysroot ${sdk_path} -m${sdk_type}-version-min=11.0 ${optimize_flags} -Wno-error=implicit-function-declaration"
    export CPPFLAGS=$CFLAGS
    export CXXFLAGS="-arch $cpu -isysroot ${sdk_path} -m${sdk_type}-version-min=11.0 ${optimize_flags} -no-cpp-precomp -stdlib=libc++ -DOPENSSL_NO_INTTYPES_H -DHAVE_CXX_STDHEADERS"
    export AR=$(xcrun -sdk $sdk_type -find ar)
    export LIBTOOL=$(xcrun -sdk $sdk_type -find libtool)
    export NM=$(xcrun -sdk $sdk_type -find nm)
    export OTOOL=$(xcrun -sdk $sdk_type -find otool)
    export RANLIB=$(xcrun -sdk $sdk_type -find ranlib)
    export STRIP=$(xcrun -sdk $sdk_type -find strip)
    export LDFLAGS="-arch $cpu -isysroot ${sdk_path}"
    
    target_dir=$ROOT/output/$build_type/$build_os

    rm -rf $target_dir
    mkdir -p $target_dir

    cd $ROOT/${LIB_NAME}
    
    # Remove previous configuration
    make clean 2> /dev/null
    make distclean 2> /dev/null

    echo "Configuring $build_type for $build_os..."
    ./Configure $ossl_target "-arch $cpu -fembed-bitcode" no-tests no-asm no-shared no-engine no-async --prefix=$target_dir

    echo "Compiling $build_type for $build_os..."
    make -j $(sysctl -n hw.physicalcpu) build_libs
    make install_dev 2> /dev/null
    echo Done

    cd $ROOT

}

# All targets are processed separately
for build_os in ios-arm64 ios-arm64-simulator ios-x86_64-simulator macos-arm64 macos-x86_64
do
    build_for $build_os debug
    build_for $build_os release
done

# Removing sources
rm -rf $ROOT/${LIB_NAME}

