if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(XMRIG_64_BIT ON)
    add_definitions(-DXMRIG_64_BIT)
else()
    set(XMRIG_64_BIT OFF)
endif()

if (NOT CMAKE_SYSTEM_PROCESSOR)
    message(WARNING "CMAKE_SYSTEM_PROCESSOR not defined")
endif()

include(CheckCXXCompilerFlag)

if (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    set(VAES_SUPPORTED ON)
else()
    CHECK_CXX_COMPILER_FLAG("-mavx2 -mvaes" VAES_SUPPORTED)
endif()

if (NOT VAES_SUPPORTED)
    set(WITH_VAES OFF)
endif()

if (XMRIG_64_BIT AND CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64)$")
    add_definitions(-DRAPIDJSON_SSE2)
else()
    set(WITH_SSE4_1 OFF)
    set(WITH_AVX2 OFF)
    set(WITH_VAES OFF)
endif()

set(CPUTYPE_REGEX_ARM8 "^(aarch64|arm64|armv8-a)$")
set(CPUTYPE_REGEX_ARM7 "^(armv7|armv7f|armv7s|armv7k|armv7-a|armv7l|armv7ve)$")
if ((CMAKE_SYSTEM_PROCESSOR MATCHES "${CPUTYPE_REGEX_ARM8}") OR (CMAKE_SYSTEM_PROCESSOR MATCHES "${CPUTYPE_REGEX_ARM7}"))
    set(ARM_TARGET 0 CACHE STRING "Force use specific ARM target 8 or 7")
    set_property(CACHE ARM_TARGET PROPERTY STRINGS 0 7 8)
    if (CMAKE_SYSTEM_PROCESSOR MATCHES "${CPUTYPE_REGEX_ARM8}")
        set(ARM_TARGET 8)
    elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "${CPUTYPE_REGEX_ARM7}")
        set(ARM_TARGET 7)
    endif()
endif()
unset(CPUTYPE_REGEX_ARM8)
unset(CPUTYPE_REGEX_ARM7)

if (ARM_TARGET AND ARM_TARGET GREATER 6)
    set(XMRIG_ARM ON)
    add_definitions(-DXMRIG_ARM=${ARM_TARGET})

    message(STATUS "Use ARM_TARGET=${ARM_TARGET} (${CMAKE_SYSTEM_PROCESSOR})")

    if (ARM_TARGET EQUAL 8)
        CHECK_CXX_COMPILER_FLAG(-march=armv8-a+crypto XMRIG_ARM_CRYPTO)

        if (XMRIG_ARM_CRYPTO)
            add_definitions(-DXMRIG_ARM_CRYPTO)
            set(ARM8_CXX_FLAGS "-march=armv8-a+crypto")
        else()
            set(ARM8_CXX_FLAGS "-march=armv8-a")
        endif()
    endif()
endif()

if (WITH_SSE4_1)
    add_definitions(-DXMRIG_FEATURE_SSE4_1)
endif()

if (WITH_AVX2)
    add_definitions(-DXMRIG_FEATURE_AVX2)
endif()
