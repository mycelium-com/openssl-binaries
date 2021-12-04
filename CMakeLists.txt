cmake_minimum_required( VERSION 3.8 )

project( openssl-static )

include( ExternalProject )

if( APPLE )
set (OPENSSL_USE_STATIC_LIBS TRUE)
set (OPENSSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME})
set (OPENSSL_INCLUDE_DIR $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/include>)
set (OPENSSL_CRYPTO_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/lib/libcrypto.a)
set (OPENSSL_SSL_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/lib/libssl.a)

if (NOT TARGET crypto)
    add_library(crypto STATIC IMPORTED)
    set_target_properties(crypto PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/lib/libcrypto.a
            INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/include>)
endif()

if (NOT TARGET ssl)
    add_library(ssl STATIC IMPORTED)
    set_target_properties(ssl PROPERTIES
        IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/lib/libssl.a
        INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${APPLE_PLATFORM_NAME}/include>)
endif()

elseif (ANDROID)
set (OPENSSL_USE_STATIC_LIBS TRUE)
set (OPENSSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI})
set (OPENSSL_INCLUDE_DIR $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include>)
set (OPENSSL_CRYPTO_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a)
set (OPENSSL_SSL_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a)
if (NOT TARGET crypto)
    add_library(crypto STATIC IMPORTED)
    set_target_properties(crypto PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a
            INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include>)
endif()

if (NOT TARGET ssl)
    add_library(ssl STATIC IMPORTED)
    set_target_properties(ssl PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a
            INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include>)
endif()

else()
message(FATAL_ERROR "Unsupported openssl target platform")
endif()

set (OPENSSL_USE_STATIC_LIBS ${OPENSSL_USE_STATIC_LIBS} PARENT_SCOPE)
set (OPENSSL_ROOT_DIR ${OPENSSL_ROOT_DIR} PARENT_SCOPE)
set (OPENSSL_INCLUDE_DIR ${OPENSSL_INCLUDE_DIR} PARENT_SCOPE)
set (OPENSSL_CRYPTO_LIBRARY ${OPENSSL_CRYPTO_LIBRARY} PARENT_SCOPE)
set (OPENSSL_SSL_LIBRARY ${OPENSSL_SSL_LIBRARY} PARENT_SCOPE)
