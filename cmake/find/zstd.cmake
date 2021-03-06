option (USE_INTERNAL_ZSTD_LIBRARY "Set to FALSE to use system zstd library instead of bundled" ${NOT_UNBUNDLED})

if(NOT EXISTS "${ClickHouse_SOURCE_DIR}/contrib/zstd/lib/zstd.h")
    if(USE_INTERNAL_ZSTD_LIBRARY)
        message(WARNING "submodule contrib/zstd is missing. to fix try run: \n git submodule update --init --recursive")
    endif()
    set(USE_INTERNAL_ZSTD_LIBRARY 0)
    set(MISSING_INTERNAL_ZSTD_LIBRARY 1)
endif()

if (NOT USE_INTERNAL_ZSTD_LIBRARY)
    find_library (ZSTD_LIBRARY zstd)
    find_path (ZSTD_INCLUDE_DIR NAMES zstd.h PATHS ${ZSTD_INCLUDE_PATHS})
endif ()

if (ZSTD_LIBRARY AND ZSTD_INCLUDE_DIR)
elseif (NOT MISSING_INTERNAL_ZSTD_LIBRARY)
    set (USE_INTERNAL_ZSTD_LIBRARY 1)
    set (ZSTD_LIBRARY zstd)
    set (ZSTD_INCLUDE_DIR ${ClickHouse_SOURCE_DIR}/contrib/zstd/lib)
endif ()

message (STATUS "Using zstd: ${ZSTD_INCLUDE_DIR} : ${ZSTD_LIBRARY}")
