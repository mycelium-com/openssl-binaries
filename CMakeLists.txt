cmake_minimum_required( VERSION 3.8 )

project( openssl )

include( ExternalProject )

if( IOS )
set (OPENSSL_USE_STATIC_LIBS TRUE PARENT_SCOPE)
set (OPENSSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME} PARENT_SCOPE)
set (OPENSSL_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/include PARENT_SCOPE)
set (OPENSSL_CRYPTO_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/lib/libcrypto.a PARENT_SCOPE)
set (OPENSSL_SSL_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/lib/libssl.a PARENT_SCOPE)

if (NOT TARGET crypto)
    add_library(crypto STATIC IMPORTED)
    set_target_properties(crypto PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/lib/libcrypto.a
            INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/include)
endif()

if (NOT TARGET ssl)
    add_library(ssl STATIC IMPORTED)
    set_target_properties(ssl PROPERTIES
        IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/lib/libssl.a
        INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/openssl_ios_build_scripts/output/${IOS_PLATFORM_NAME}/include)
endif()

elseif (ANDROID)
set (OPENSSL_USE_STATIC_LIBS TRUE PARENT_SCOPE)
set (OPENSSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI} PARENT_SCOPE)
set (OPENSSL_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include PARENT_SCOPE)
set (OPENSSL_CRYPTO_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a PARENT_SCOPE)
set (OPENSSL_SSL_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a PARENT_SCOPE)

if (NOT TARGET crypto)
    add_library(crypto STATIC IMPORTED)
    set_target_properties(crypto PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libcrypto.a
            INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include)
endif()

if (NOT TARGET ssl)
    add_library(ssl STATIC IMPORTED)
    set_target_properties(ssl PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/lib/libssl.a
            INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/openssl_build_scripts/output/android/openssl-${ANDROID_ABI}/include)
endif()

else()
message(FATAL_ERROR "Unsupported openssl target platform")
endif()
