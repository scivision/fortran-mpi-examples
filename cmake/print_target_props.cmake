execute_process(COMMAND ${CMAKE_COMMAND} --help-property-list
OUTPUT_VARIABLE _props OUTPUT_STRIP_TRAILING_WHITESPACE
)

STRING(REGEX REPLACE "\n" ";" _props "${_props}")

list(REMOVE_DUPLICATES _props)

function(print_target_props tgt)
    if(NOT TARGET ${tgt})
        message(WARNING "Target ${tgt} not found")
        return()
    endif()

    message(STATUS "Target: ${tgt} properties")
    foreach(p IN LISTS _props)
        if(p MATCHES "<CONFIG>" AND NOT CMAKE_BUILD_TYPE)
          continue()
        endif()

        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" p "${p}")

        get_property(v TARGET ${tgt} PROPERTY "${p}")
        if(v)
            message(STATUS "${tgt} ${p} = ${v}")
        endif()
    endforeach()
endfunction()
