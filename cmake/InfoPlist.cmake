function(preprocess_info_plist Target)
    set(options)
    set(oneValueArgs PLIST OUTPUT)
    set(multiValueArgs DEFINES)
    cmake_parse_arguments(_PP "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    #cmake_print_variables(_PP_OUTPUT _PP_PLIST _PP_DEFINES)
    if (NOT ${CMAKE_GENERATOR} STREQUAL "Xcode")
        # | egrep -v '^\#'  > '${_PP_OUTPUT}'")
        separate_arguments(Cmd UNIX_COMMAND "${PreCmd}")
        execute_process (
            COMMAND ${CMAKE_CXX_COMPILER} -x c -w -CC -E ${_PP_DEFINES} ${_PP_PLIST}
            OUTPUT_FILE ${_PP_OUTPUT}.tmp
            )
        execute_process (
            COMMAND sed -E -e "s|\\$\\((.+)\)|$\\{\\1\\}|" -e "/^#/d" 
            INPUT_FILE ${_PP_OUTPUT}.tmp
            OUTPUT_FILE ${_PP_OUTPUT}
            )
    endif()
endfunction()
