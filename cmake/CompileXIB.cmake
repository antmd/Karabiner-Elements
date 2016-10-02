
function(compile_xib Target ResourcesVar ResourcesBuildDir)


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

        set(CreatedDirs)
        # Compile the .xib files using the 'ibtool' program with the destination being the app package
        foreach(x ${${ResourcesVar}})
            if (IS_ABSOLUTE ${x})
                file(RELATIVE_PATH xib ${CMAKE_CURRENT_SOURCE_DIR} ${x})
            else()
                set(xib ${x})
            endif()

            get_filename_component(XibFile ${xib} NAME)
            get_filename_component(XibName ${xib} NAME_WE)
            get_filename_component(NibDir ${ResourcesBuildDir}/${xib} DIRECTORY)

            list(FIND CreatedDirs ${NibDir} Pos)
            if (Pos EQUAL -1)
                add_custom_command (
                    TARGET ${Target} PRE_BUILD
                    COMMAND mkdir -p "${NibDir}"
                    )
                list(APPEND CreatedDirs ${NibDir})
            endif()

            set(NibPath ${NibDir}/${XibName}.nib)
            set(XibPath ${CMAKE_CURRENT_SOURCE_DIR}/${xib})

            if (${xib} MATCHES .*\.xib)
                add_custom_command (TARGET ${Target} POST_BUILD 
                    COMMAND ${XCRUN} ibtool 
                        --errors
                        --warnings
                        --notices
                        --output-format human-readable-text 
                        --compile ${NibPath} ${XibPath}
                    COMMENT "Compiling ${xib}")
            else()
                add_custom_command(TARGET ${Target} POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy ${XibPath} ${NibDir}/${XibFile}
                    )
            endif()

        endforeach()


    endif() # Generator is NOT Xcode

endfunction()
