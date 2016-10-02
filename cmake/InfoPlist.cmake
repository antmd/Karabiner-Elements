function(preprocess_info_plist Target)
    set(options)
    set(oneValueArgs PLIST)
    set(multiValueArgs DEFINES)
    cmake_parse_arguments(_PP "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    cmake_print_variables(_PP_DEFINES _PP_PLIST)
    if (NOT ${CMAKE_GENERATOR} STREQUAL "Xcode")
        set(PreCmd "${CMAKE_CXX_COMPILER} -x c -w  -E ${_PP_DEFINES} '${_PP_PLIST}' | egrep -v '^\#' > '${_PP_PLIST}.tmp'")
        separate_arguments(Cmd UNIX_COMMAND "${PreCmd}")
        add_custom_command (
            TARGET ${Target} PRE_BUILD
            COMMAND ${Cmd}
            COMMAND mv "${_PP_PLIST}.tmp" "${_PP_PLIST}"
            )
    endif()
endfunction()
