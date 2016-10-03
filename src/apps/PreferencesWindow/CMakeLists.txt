cmake_minimum_required( VERSION 3.2 )

project(PreferencesWindow VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake")
include(Variables)
include(CompileXIB)
include(CMakePrintHelpers)
include(InfoPlist)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(InfoPlistTmpl "${CMAKE_CURRENT_SOURCE_DIR}/PreferencesWindow/Info.plist.tmpl")

set(RESOURCE_FILES
    PreferencesWindow/Base.lproj/MainMenu.xib
    )

set(INCLUDE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/../share/Relauncher.h
    PreferencesWindow/AppDelegate.h
    PreferencesWindow/LogFileTextViewController.h
    PreferencesWindow/PreferencesWindowController.h
    PreferencesWindow/UpdaterController.h
    )

set(SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/../share/Relauncher.m
    PreferencesWindow/AppDelegate.m
    PreferencesWindow/LogFileTextViewController.m
    PreferencesWindow/PreferencesWindowController.m
    PreferencesWindow/UpdaterController.m
    PreferencesWindow/main.m
    )

# EXECUTABLE
# ---------------
add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCE_FILES} ${INCLUDE_FILES})

target_compile_options(
    ${PROJECT_NAME} PUBLIC 
    -fobjc-arc
    -fmodules
    -Wno-deprecated-declarations
    )

target_include_directories(
    ${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Classes
    ${CMAKE_CURRENT_SOURCE_DIR}/../share
    )

target_link_libraries(
    ${PROJECT_NAME} PRIVATE
    libkrbn
    )

set(InfoPlist ${CMAKE_CURRENT_BINARY_DIR}/Info.plist)
preprocess_info_plist(
    ${PROJECT_NAME} 
    PLIST ${InfoPlistTmpl}
    OUTPUT ${InfoPlist}
    DEFINES -DPKGVERSION=100
    )

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_INFO_STRING "${PROJECT_VERSION}, ${CopyrightString}"
    MACOSX_BUNDLE_INFO_PLIST ${InfoPlist}
    #MACOSX_BUNDLE_ICON_FILE "Logo"
    MACOSX_BUNDLE_GUI_IDENTIFIER "${CompanyName}.${PROJECT_NAME}"
    MACOSX_BUNDLE_LONG_VERSION_STRING "${PROJECT_VERSION}"
    MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_COPYRIGHT "${CopyrightString}"
    )


if (${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "Yes")
    set_target_properties(${PROJECT_NAME} PROPERTIES XCODE_ATTRIBUTE_WRAPPER_EXTENSION "app")
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/\${CONFIGURATION})
else()
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR})
endif()

# The app bundle directory in the build directory
set(AppBundle ${PROJECT_NAME}.app)
set(AppBundleBuildDir ${BundleBuildPath}/${AppBundle})
set(ContentsBuildDir ${AppBundleBuildDir}/Contents)
set(ResourcesBuildDir ${ContentsBuildDir}/Resources)

target_add_resources(
    ${PROJECT_NAME} 
    RESOURCES_VAR RESOURCE_FILES 
    BUILD_DIR "${ResourcesBuildDir}"
    BASE_DIR PreferencesWindow
    )

# INSTALL
# -------
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Installed)
set(InstallDir ${CMAKE_INSTALL_PREFIX})
install (
    TARGETS ${PROJECT_NAME}
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
set(PRODUCT_NAME ${PROJECT_NAME})
set(MACOSX_DEPLOYMENT_TARGET 10.12)
set(EXECUTABLE_NAME ${PROJECT_NAME})

configure_file(${FixupBundleTemplate} ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)
install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

