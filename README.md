# openssl-binaries

This project provides CMake wrapper for openssl libraries.

### Requirements
Setup your environment properly, i.e. install either XCode or Android NDK and Android SDk, depending on your target platform.

If you're targeting Android platform then define ```ANDROID_HOME``` and ```ANDROID_NDK_ROOT``` environment variables:

    export ANDROID_HOME=/Path/to/Android/sdk
    export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/ndk_version


### How to use?

1. Add this project as either git submodule or subdirectory and then reference this directory in your CMakeLists.txt file using ```add_subdirectory``` command.
2. Go to ```openssl_build_scripts/tools``` directory and run ```build-android-openssl.sh``` or ```build-ios-openssl.sh``` respectively.
3. It's done, libraries are built and ready for linking with your application.
