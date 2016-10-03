cmake_minimum_required( VERSION 3.2 )

project(Updater VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake")
include(Variables)
include(CompileXIB)
include(AddFramework)
include(CMakePrintHelpers)
include(InfoPlist)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(InfoPlistTmpl "${CMAKE_CURRENT_SOURCE_DIR}/Updater/Info.plist.tmpl")

set(RESOURCE_FILES
    Updater/Base.lproj/MainMenu.xib
    )

set(INCLUDE_FILES
    #${CMAKE_CURRENT_SOURCE_DIR}/../share/Relauncher.h
    Updater/AppDelegate.h
    )

set(SOURCE_FILES
    #${CMAKE_CURRENT_SOURCE_DIR}/../share/Relauncher.m
    Updater/AppDelegate.m
    Updater/main.m
    )

# EXECUTABLE
# ---------------
add_executable(Updater MACOSX_BUNDLE ${SOURCE_FILES} ${INCLUDE_FILES})
set(BundleName "Karabiner-Elements")

target_compile_options(
    Updater PUBLIC 
    -fobjc-arc
    -fmodules
    -Wno-deprecated-declarations
    )

target_include_directories(
    Updater PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Classes
    ${CMAKE_CURRENT_SOURCE_DIR}/../share
    )

target_add_framework(
    Updater PRIVATE
    FRAMEWORK Sparkle
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Pods/Sparkle
    )

target_link_libraries(
    Updater PRIVATE
    libkrbn
    ${FRAMEWORK_Sparkle}
    )

set(InfoPlist ${CMAKE_CURRENT_BINARY_DIR}/Info.plist)
preprocess_info_plist(
    Updater
    PLIST ${InfoPlistTmpl}
    OUTPUT ${InfoPlist}
    DEFINES -DPKGVERSION=100
    )

set_target_properties(Updater PROPERTIES
    MACOSX_BUNDLE_INFO_STRING "${PROJECT_VERSION}, ${CopyrightString}"
    MACOSX_BUNDLE_INFO_PLIST ${InfoPlist}
    #MACOSX_BUNDLE_ICON_FILE "Logo"
    MACOSX_BUNDLE_GUI_IDENTIFIER "${CompanyName}.${BundleName}-Updater"
    MACOSX_BUNDLE_LONG_VERSION_STRING "${PROJECT_VERSION}"
    MACOSX_BUNDLE_BUNDLE_NAME "${BundleName}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_COPYRIGHT "${CopyrightString}"
    OUTPUT_NAME "${BundleName}"
    )


if (${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(Updater PROPERTIES XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "Yes")
    set_target_properties(Updater PROPERTIES XCODE_ATTRIBUTE_WRAPPER_EXTENSION "app")
    set_target_properties(Updater PROPERTIES XCODE_ATTRIBUTE_PRODUCT_NAME "${BundleName}")
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR}/Updater/\${CONFIGURATION})
else()
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR})
endif()

# The app bundle directory in the build directory
set(AppBundle ${BundleName}.app)
set(AppBundleBuildDir ${BundleBuildPath}/${AppBundle})
set(ContentsBuildDir ${AppBundleBuildDir}/Contents)
set(ResourcesBuildDir ${ContentsBuildDir}/Resources)

target_add_resources(
    Updater
    RESOURCES_VAR RESOURCE_FILES 
    BUILD_DIR "${ResourcesBuildDir}"
    BASE_DIR Updater
    )

# INSTALL
# -------
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Installed)
set(InstallDir ${CMAKE_INSTALL_PREFIX}/updater)
install (
    TARGETS Updater
    LIBRARY DESTINATION ${InstallDir}
    ARCHIVE DESTINATION ${InstallDir}
    RUNTIME DESTINATION ${InstallDir}
    BUNDLE  DESTINATION ${InstallDir}
    )

# 'Fixup' bundle
# -------
set(BUNDLE "${InstallDir}/${AppBundle}")
set(OTHER_DIRS ${FrameworkDirs})

# Exported variables for Info.plist
set(PRODUCT_NAME ${BundleName})
set(MACOSX_DEPLOYMENT_TARGET 10.12)
set(EXECUTABLE_NAME ${BundleName})

configure_file(${FixupBundleTemplate} ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)
install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

