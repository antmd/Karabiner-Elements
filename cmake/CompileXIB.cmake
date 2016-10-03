
function(target_add_resources Target)

    set(options)
    set(oneValueArgs RESOURCES_VAR BUILD_DIR BASE_DIR)
    set(multiValueArgs)
    cmake_parse_arguments(_ART "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    set(ResourcesVar ${_ART_RESOURCES_VAR})
    set(ResourcesBuildDir ${_ART_BUILD_DIR})
    set(ResourcesBaseDir ${_ART_BASE_DIR})
    if (NOT ResourcesBaseDir)
        set(ResourcesBaseDir ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    #cmake_print_variables(_ART_RESOURCES_VAR _ART_BUILD_DIR _ART_BASE_DIR)
    #message("Resources = ${${_ART_RESOURCES_VAR}}")

    # If generator isn't Xcode, we need to generate the app bundle 'manually' at build-time, to allow testing
    # Make sure the 'Resources' Directory is correctly created before we build
    if (NOT ${CMAKE_GENERATOR} STREQUAL "Xcode")

        # Make sure we can find the 'ibtool' program. If we can NOT find it we
        # skip generation of this project
        find_program(XCRUN xcrun HINTS "/usr/bin" "${OSX_DEVELOPER_ROOT}/usr/bin")
        if (${XCRUN} STREQUAL "XCRUN-NOTFOUND")
            message(SEND_ERROR "xcrun can not be found and is needed to compile the .xib files. It should have been installed with 
            the Apple developer tools. The default system paths were searched in addition to ${OSX_DEVELOPER_ROOT}/usr/bin")
        endif()

        if (IS_ABSOLUTE ${ResourcesBuildDir})
            file(RELATIVE_PATH ResourcesBuildDir ${CMAKE_CURRENT_BINARY_DIR} ${ResourcesBuildDir})
        endif()
        get_filename_component(AbsResourcesBaseDir ${ResourcesBaseDir} ABSOLUTE)

        # 'Compile' the resource files, with the destination being the app package in the build dirs
        foreach(ResourceFilePath ${${ResourcesVar}})
            get_filename_component(AbsResourceFilePath ${ResourceFilePath} ABSOLUTE)
            file(RELATIVE_PATH ResourceBaseDirRelativePath ${AbsResourcesBaseDir} ${AbsResourceFilePath})

            get_filename_component(ResourceFilename ${ResourceBaseDirRelativePath} NAME)
            get_filename_component(ResourceOutputDir ${ResourcesBuildDir}/${ResourceBaseDirRelativePath} DIRECTORY)
            get_filename_component(XibPath ${AbsResourceFilePath} ABSOLUTE)

            # Resource 'compile' rules
            if (${ResourceFilePath} MATCHES .*\.xib)
                # .xib -- compile using ibtool
                get_filename_component(XibName ${ResourceFilename} NAME_WE)
                set(NibPath ${ResourceOutputDir}/${XibName}.nib)

                #cmake_print_variables(NibPath AbsResourceFilePath)
                add_custom_command (TARGET ${Target} POST_BUILD 
                    COMMAND mkdir -p "${ResourceOutputDir}"
                    COMMAND ${XCRUN} ibtool 
                        --errors
                        --warnings
                        --notices
                        --output-format human-readable-text 
                        --compile ${NibPath} ${AbsResourceFilePath}
                        COMMENT "Compiling ${ResourceBaseDirRelativePath}")
            else()
                # Everything else -- just copy
                add_custom_command(TARGET ${Target} POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy ${AbsResourceFilePath} ${ResourceOutputDir}/${ResourceFilename}
                    )
            endif()

        endforeach()


    endif() # Generator is NOT Xcode

endfunction()
