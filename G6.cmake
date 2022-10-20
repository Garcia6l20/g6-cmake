list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

get_directory_property(HAS_PARENT PARENT_DIRECTORY)
if(HAS_PARENT)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endif()

set(G6_CMAKE ON)

include(G6Warnings)
include(G6Sanitizers)
include(G6StaticAnalyzers)

if(BUILD_TESTING)
    include(G6Testing)
endif()

include(GNUInstallDirs)
install(TARGETS g6-warnings EXPORT g6-cmake-targets)
install(EXPORT g6-cmake-targets
  DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/G6"
  )
