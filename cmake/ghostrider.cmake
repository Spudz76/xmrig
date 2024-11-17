if (WITH_GHOSTRIDER)
    add_definitions(/DXMRIG_ALGO_GHOSTRIDER)
    add_subdirectory(src/crypto/ghostrider)
    set(GHOSTRIDER_LIBRARY ghostrider)
    if (WITH_FLEX)
        add_definitions(/DXMRIG_ALGO_FLEX)
        list(APPEND SOURCES_CRYPTO
            src/crypto/flex/flex.cpp
            src/crypto/flex/flex_keccak.c
            )
    else()
        remove_definitions(/DXMRIG_ALGO_FLEX)
    endif()
else()
    remove_definitions(/DXMRIG_ALGO_GHOSTRIDER)
    remove_definitions(/DXMRIG_ALGO_FLEX)
    set(GHOSTRIDER_LIBRARY "")
endif()
