list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

get_directory_property(HAS_PARENT PARENT_DIRECTORY)
if(HAS_PARENT)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endif()

set(G6_CMAKE ON)

include(G6Warnings)
include(G6Sanitizers)

if(BUILD_TESTING)
    include(G6Testing)
endif()
