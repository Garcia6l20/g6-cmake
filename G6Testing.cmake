find_package(Catch2 REQUIRED)

add_library(g6-unit-tests-main ${CMAKE_CURRENT_LIST_DIR}/src/catch2_main.cpp)
target_link_libraries(g6-unit-tests-main PUBLIC Catch2::Catch2)
if(WIN32)
  target_compile_options(g6-unit-tests-main PRIVATE /EHsc)
endif()
add_library(g6::ut ALIAS g6-unit-tests-main)

set(G6_TESTING_SANITIZER OFF CACHE INTERNAL "Sanitizer to use for tests")

##
## add_test overload
##
## add_test(BASE_TEST_SOURCE [TARGET out_target_name] [EXTRA_SOURCE_FILE...])
##
## Arguments:
##  - TARGET [out]: get the generated target
function(g6_add_unit_test _base_test_source)

  get_filename_component(_name "${_base_test_source}" NAME_WE)

  set(_arg_options)
  set(_arg_one_value_options TARGET SANITIZER)
  set(_arg_multi_value_options)
  cmake_parse_arguments(ARG "${_arg_options}" "${_arg_one_value_options}" "${_arg_multi_value_options}" ${ARGN})

  set(_target ${PROJECT_NAME}-${_name})

  add_executable(${_target} ${_name}.cpp ${ARG_UNPARSED_ARGUMENTS})
  target_link_libraries(${_target} PRIVATE g6::ut)

  add_test(NAME ${PROJECT_NAME}-${_name} COMMAND ${PROJECT_NAME}-${_name})

  if (NOT TARGET ${PROJECT_NAME}-tests)
    add_custom_target(${PROJECT_NAME}-tests)
  endif()

  if (ARG_SANITIZER)
    target_link_libraries(${_target} PRIVATE g6::sanitizer::${ARG_SANITIZER})
  elseif(G6_TESTING_SANITIZER)
    message(STATUS "using ${G6_TESTING_SANITIZER} sanitizer")
    target_link_libraries(${_target} PRIVATE g6::sanitizer::${G6_TESTING_SANITIZER})
  endif()

  add_dependencies(${PROJECT_NAME}-tests ${_target})

  if(ARG_TARGET)
    set(${ARG_TARGET} ${_target} PARENT_SCOPE)
  endif()
endfunction()
