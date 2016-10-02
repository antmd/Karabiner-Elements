function(preprocess_info_plist Target)
    set(options)
    set(oneValueArgs PLIST)
    set(multiValueArgs DEFINES)
    cmake_parse_arguments(_PP "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    if (NOT ${CMAKE_GENERATOR} STREQUAL "Xcode")
        set(PreCmd "${CMAKE_CXX_COMPILER} -x c -w  -E ${_PP_DEFINES} '${_PP_PLIST}' | egrep -v '^\#'  > '${_PP_PLIST}.tmp'")
        separate_arguments(Cmd UNIX_COMMAND "${PreCmd}")
        get_filename_component(Dir ${_PP_PLIST} DIRECTORY)
        add_custom_command (
            TARGET ${Target} PRE_BUILD
            COMMAND mkdir -p "${Dir}"
            COMMAND ${Cmd}
            COMMAND sed -E "\'s|\\$$\\((.+)\\)|$$\{\\1}|\'" "${_PP_PLIST}.tmp" > "${_PP_PLIST}"
            )
    endif()
endfunction()
