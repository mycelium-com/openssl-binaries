cmake_minimum_required( VERSION 3.8 )

project( openssl )

include( ExternalProject )

if( IOS )
add_library(crypto STATIC IMPORTED)
set_target_properties(crypto
  PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libcrypto.a)

add_library(ssl STATIC IMPORTED)
set_target_properties(ssl
  PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/openssl_build_scripts/output/ios/openssl-${IOS_ARCH}/lib/libssl.a)
endif()

if (ANDROID)
add_library(crypto STATIC IMPORTED)
set_target_properties(crypto
  PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a)

add_library(ssl STATIC IMPORTED)
set_target_properties(ssl
  PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a)
endif()
