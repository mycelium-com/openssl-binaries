cmake_minimum_required( VERSION 3.8 )

project( openssl )

include( ExternalProject )

if( IOS )
set (OPENSSL_USE_STATIC_LIBS TRUE PARENT_SCOPE)
set (OPENSSL_ROOT_DIR openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH} PARENT_SCOPE)
set (OPENSSL_INCLUDE_DIR openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/include PARENT_SCOPE)
set (OPENSSL_LIBRARIES openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib PARENT_SCOPE)
set (OPENSSL_CRYPTO_LIBRARY openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libcrypto.a PARENT_SCOPE)
set (OPENSSL_SSL_LIBRARY openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libssl.a PARENT_SCOPE)

add_library(crypto STATIC IMPORTED)
set_target_properties(crypto PROPERTIES IMPORTED_LOCATION openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libcrypto.a)
add_library(ssl STATIC IMPORTED)
set_target_properties(ssl PROPERTIES IMPORTED_LOCATION openssl-binaries/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libssl.a)

endif()

if (ANDROID)
set (OPENSSL_USE_STATIC_LIBS TRUE PARENT_SCOPE)
set (OPENSSL_ROOT_DIR openssl-binaries/openssl_build_scripts/output/android/openssl-${ANDROID_ABI} PARENT_SCOPE)
set (OPENSSL_INCLUDE_DIR openssl-binaries/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include PARENT_SCOPE)
set (OPENSSL_CRYPTO_LIBRARY openssl-binaries}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a PARENT_SCOPE)
set (OPENSSL_SSL_LIBRARY openssl-binaries/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a PARENT_SCOPE)
set (OPENSSL_LIBRARIES ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY} PARENT_SCOPE)

add_library(crypto STATIC IMPORTED)
set_target_properties(crypto PROPERTIES IMPORTED_LOCATION openssl-binaries/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a)
add_library(ssl STATIC IMPORTED)
set_target_properties(ssl PROPERTIES IMPORTED_LOCATION openssl-binaries/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a)

endif()
