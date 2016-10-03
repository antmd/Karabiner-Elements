
set(ADDED_FRAMEWORKS)

# Used to collect framework directories added by 'target_add_framework', and will be passed to fixup_bundle
macro(target_add_framework target)
    set(options PUBLIC PRIVATE INTERFACE)
    set(oneValueArgs FRAMEWORK DIRECTORY FRAMEWORKS_VAR)
    set(multiValueArgs)
    cmake_parse_arguments(_TAF "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    set(fwname ${_TAF_FRAMEWORK})
    set(fwdir ${_TAF_DIRECTORY})
    if (${_TAF_FRAMEWORKS_VAR})
        set(fwvar ${_TAF_FRAMEWORKS_VAR})
    else()
        set(fwvar ADDED_FRAMEWORKS)
    endif()

    if (_TAF_PUBLIC)
        set(visibility PUBLIC)
    elseif (_TAF_PRIVATE)
        set(visibility PRIVATE)
    elseif (_TAF_INTERFACE)
        set(visibility INTERFACE)
    endif()

    find_library(
        FRAMEWORK_${fwname}
        NAMES ${fwname}
        PATHS ${fwdir}
            /System/Library/Frameworks
        NO_DEFAULT_PATH
        )
    if( ${FRAMEWORK_${fwname}} STREQUAL FRAMEWORK_${fwname}-NOTFOUND)
        MESSAGE(ERROR ": Framework ${fwname} not found")
    else()
        get_filename_component(FRAMEWORK_DIR ${FRAMEWORK_${fwname}} DIRECTORY)
        list(FIND ${fwvar} ${FRAMEWORK_DIR} FrameworkIdx)
        if (FrameworkIdx EQUAL -1)
            list(APPEND ${fwvar} ${FRAMEWORK_DIR})
        endif()
        target_link_libraries(${target} ${visibility} ${FRAMEWORK_${fwname}})
        get_target_property(target_rpaths ${target} INSTALL_RPATH)
        set_target_properties(${target} PROPERTIES INSTALL_RPATH "${target_rpaths};${FRAMEWORK_DIR}")
        MESSAGE(STATUS "Framework ${fwname} found at ${FRAMEWORK_${fwname}}")
    endif()
endmacro(target_add_framework)

