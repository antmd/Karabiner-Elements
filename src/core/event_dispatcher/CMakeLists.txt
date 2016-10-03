cmake_minimum_required( VERSION 3.2 )

project(event_dispatcher VERSION 0.1.0)

################################
# event_dispatcher
################################

# ------
# SOURCE
# ------

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(INCLUDE_FILES
    include/logger.hpp
    include/receiver.hpp
    )

set(SOURCE_FILES
    main.cpp
    )


find_package(Boost MODULE REQUIRED)

# ----------
# EXECUTABLE
# ----------

add_executable(event_dispatcher ${SOURCE_FILES} ${INCLUDE_FILES})

set_target_properties(
    event_dispatcher
    PROPERTIES
    OUTPUT_NAME karabiner_event_dispatcher
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    )

if (${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(console_user_server PROPERTIES XCODE_ATTRIBUTE_PRODUCT_NAME "karabiner_event_dispatcher")
endif()

target_link_libraries(
    event_dispatcher
    PRIVATE
    karabiner_shared
    "-framework Foundation"
    "-framework IOKit"
    "-framework SystemConfiguration"
    )

target_include_directories(
    event_dispatcher 
    PRIVATE
    ${CMAKE_BINARY_DIR}/include
    include
    ${Boost_INCLUDE_DIRS}
    ../../vendor
    )

target_compile_options(
    event_dispatcher 
    PRIVATE
    -Wno-deprecated-declarations
    )


# -------
# INSTALL
# -------

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Installed)
install (
    TARGETS event_dispatcher
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )
