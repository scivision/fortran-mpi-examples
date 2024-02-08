if(NOT MSVC)
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wall>)
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-Wall>)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-warn>)
endif()
