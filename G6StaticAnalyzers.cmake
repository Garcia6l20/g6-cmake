option(G6_STATIC_ANALYZERS_ENABLED "Enable static analysis" OFF)
option(G6_STATIC_ANALYZERS_WARNINGS_AS_ERROR "Treat warning as error for static analysis" OFF)

if(NOT G6_STATIC_ANALYZERS_ENABLED)
    return()
endif()

set(G6_CPPCHECK_OPTIONS
    --enable=style,performance,warning,portability
    --inline-suppr

    # We cannot act on a bug/missing feature of cppcheck
    --suppress=internalAstError

    # if a file does not have an internalAstError, we get an unmatchedSuppression error
    --suppress=unmatchedSuppression
    --inconclusive
    CACHE STRING "cppcheck options"
)
set_property(CACHE G6_CPPCHECK_OPTIONS PROPERTY STRINGS)

find_program(CPPCHECK cppcheck)

if(CPPCHECK)
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK} ${CPPCHECK_OPTIONS})

    if(NOT
        "${CMAKE_CXX_STANDARD}"
        STREQUAL
        "")
        set(CMAKE_CXX_CPPCHECK ${CMAKE_CXX_CPPCHECK} --std=c++${CMAKE_CXX_STANDARD})
    endif()

    if(WARNINGS_AS_ERRORS)
        list(APPEND CMAKE_CXX_CPPCHECK --error-exitcode=2)
    endif()
else()
    message(WARNING "cppcheck requested but executable not found")
endif()

find_program(CLANGTIDY clang-tidy)

if(CLANGTIDY)
    # construct the clang-tidy command line
    set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY} -extra-arg=-Wno-unknown-warning-option)
    option(G6_CLAND_TIDY_USE_STDLIB "Use lidstdc++ rather than libc++" OFF)
    # set standard
    if(NOT
        "${CMAKE_CXX_STANDARD}"
        STREQUAL
        "")
        if("${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE}" STREQUAL "cl")
            set(CMAKE_CXX_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY} -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
        else()
            set(CMAKE_CXX_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
        endif()
    endif()

    if(G6_CLAND_TIDY_USE_STDLIB)
        set(CMAKE_CXX_CLANG_TIDY ${CMAKE_CXX_CLANG_TIDY} --extra-arg-before=-stdlib=libstdc++)
    endif()

    # set warnings as errors
    if(G6_STATIC_ANALYZERS_WARNINGS_AS_ERROR)
        list(APPEND CMAKE_CXX_CLANG_TIDY -warnings-as-errors=*)
    endif()
else()
    message(WARNING "clang-tidy requested but executable not found")
endif()
