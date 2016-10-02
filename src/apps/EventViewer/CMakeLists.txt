cmake_minimum_required( VERSION 3.2 )

project(EventViewer VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake")
include(Variables)
include(CompileXIB)
include(CMakePrintHelpers)
include(InfoPlist)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(InfoPlist "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.tmpl")

set(RESOURCE_FILES
    English.lproj/MainMenu.xib
    English.lproj/InfoPlist.strings
    )

set(EventViewer_INCLUDE_FILES
    AppDelegate.h
    Classes/EventQueue.h
    Classes/EventViewerApplication.h
    Classes/KeyResponder.h
    Classes/PreferencesKeys.h
    Classes/PreferencesManager.h
    Classes/TabView.h
    )

set(EventViewer_SOURCE_FILES
    Classes/EventQueue.m
    Classes/EventViewerApplication.m
    Classes/KeyResponder.m
    Classes/PreferencesManager.m
    Classes/TabView.m
    AppDelegate.m
    main.m
    )

# EXECUTABLE EventViewer
# ---------------
add_executable(EventViewer MACOSX_BUNDLE ${EventViewer_SOURCE_FILES} ${EventViewer_INCLUDE_FILES})

target_compile_options(
    EventViewer PUBLIC 
    -fobjc-arc
    -fmodules
    -Wno-deprecated-declarations
    )

target_include_directories(
    EventViewer PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Classes
    ${CMAKE_CURRENT_SOURCE_DIR}/../share
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

preprocess_info_plist(${PROJECT_NAME} 
    PLIST ${ContentsBuildDir}/Info.plist
    DEFINES -DPKGVERSION=100)
compile_xib(${PROJECT_NAME} RESOURCE_FILES "${ResourcesBuildDir}")

# INSTALL EventViewer
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

