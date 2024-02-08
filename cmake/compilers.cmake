if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang|Intel")
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wall>)
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
  add_compile_options(
  "$<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Debug,RelWithDebInfo>>:-Wextra>"
  )
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-Wall>)
  add_compile_options(
    "$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug,RelWithDebInfo>>:-Wextra;-fcheck=all;-Werror=array-bounds>"
    )

elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  add_compile_options(
  "$<$<COMPILE_LANGUAGE:Fortran>:-warn>"
  "$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug,RelWithDebInfo>>:-check;-traceback>"
  "$<$<CONFIG:Debug>:-Rno-debug-disables-optimization>"
  )
endif()
