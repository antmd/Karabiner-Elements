cmake_minimum_required( VERSION 3.2 )

project(VirtualHIDManager VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../cmake")
include(Variables)
include(CompileXIB)
include(AddFramework)
include(InfoPlist)

set(KextModuleVersion "1.0.0d1")

# For Objective-C++, the compiler is clang, and the linker is clang++
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE string "clang compiler" FORCE)
set(CMAKE_CXX_COMPILER "/usr/bin/clang" CACHE string "clang compiler" FORCE)
SET(CMAKE_C_LINK_EXECUTABLE "/usr/bin/clang++ <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" CACHE string "clang linker" FORCE)
SET(CMAKE_CXX_LINK_EXECUTABLE "/usr/bin/clang++ <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" CACHE string "clang linker" FORCE)
################################
# VirtualHIDManager
################################

# ------
# SOURCE
# ------

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(InfoPlistTmpl "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.tmpl")

set(INCLUDE_FILES
    UserClient.hpp
    VirtualHIDManager.hpp
    include/ServiceDetector.hpp
    )

set(SOURCE_FILES
    UserClient.cpp
    VirtualHIDManager.cpp
    )

find_package(Boost MODULE REQUIRED)

# ----------
# EXECUTABLE
# ----------

add_executable(VirtualHIDManager MACOSX_BUNDLE ${SOURCE_FILES} ${INCLUDE_FILES})

set_target_properties(
    VirtualHIDManager
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    )

find_library(FOUNDATION_FRAMEWORK Foundation REQUIRED)
find_library(IOKIT_FRAMEWORK IOKit REQUIRED)

target_link_libraries(
    VirtualHIDManager
    PRIVATE
    karabiner_shared
    ${FOUNDATION_FRAMEWORK}
    ${IOKIT_FRAMEWORK}
    )

target_include_directories(
    VirtualHIDManager 
    PRIVATE
    ${CMAKE_BINARY_DIR}/include
    include
    ../share
    ${Boost_INCLUDE_DIRS}
    ../../vendor
    )

target_compile_options(
    VirtualHIDManager 
    PRIVATE
    -xobjective-c++
    -fobjc-arc
    -fmodules
    -fcxx-modules
    -Xclang
    -stdlib=libc++
    -Wno-deprecated-declarations
    )


if (${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(VirtualHIDManager PROPERTIES XCODE_ATTRIBUTE_MODULE_NAME "org.pqrs.driver.VirtualHIDManager")
    set_target_properties(VirtualHIDManager PROPERTIES XCODE_ATTRIBUTE_MODULE_VERSION "${KextModuleVersion}")
    set_target_properties(VirtualHIDManager PROPERTIES XCODE_ATTRIBUTE_WRAPPER_EXTENSION "kext")
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/\${CONFIGURATION})
else()
    set(BundleBuildPath ${CMAKE_CURRENT_BINARY_DIR})
endif()

set(InfoPlist ${CMAKE_CURRENT_BINARY_DIR}/Info.plist)
preprocess_info_plist(
    VirtualHIDManager
    PLIST ${InfoPlistTmpl}
    OUTPUT ${InfoPlist}
    DEFINES -DPKGVERSION="${KextModuleVersion}"
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

# The app bundle directory in the build directory
set(AppBundle ${PROJECT_NAME}.app)
set(AppBundleBuildDir ${BundleBuildPath}/${AppBundle})
set(ContentsBuildDir ${AppBundleBuildDir}/Contents)
set(ResourcesBuildDir ${ContentsBuildDir}/Resources)


# -------
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
