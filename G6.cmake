list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

set(G6_CMAKE ON)

include(G6Warnings)
include(G6Sanitizers)

if(BUILD_TESTING)
    include(G6Testing)
endif()
