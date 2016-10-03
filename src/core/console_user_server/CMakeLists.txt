cmake_minimum_required( VERSION 3.2 )

project(console_user_server VERSION 0.1.0)

################################
# console_user_server
################################

# ------
# SOURCE
# ------

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(INCLUDE_FILES
    include/configuration_manager.hpp
    include/connection_manager.hpp
    include/logger.hpp
    )

set(SOURCE_FILES
    main.cpp
    )


find_package(Boost MODULE REQUIRED)

# ----------
# EXECUTABLE
# ----------

add_executable(console_user_server ${SOURCE_FILES} ${INCLUDE_FILES})

set_target_properties(
    console_user_server
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    )

target_link_libraries(
    console_user_server
    PRIVATE
    karabiner_shared
    "-framework Foundation"
    "-framework Carbon"
    "-framework SystemConfiguration"
    )

target_include_directories(
    console_user_server 
    PRIVATE
    ${CMAKE_BINARY_DIR}/include
    include
    ${Boost_INCLUDE_DIRS}
    ../../vendor
    )

target_compile_options(
    console_user_server 
    PRIVATE
    -Wno-deprecated-declarations
    )

# -------
# INSTALL
# -------

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Installed)
install (
    TARGETS console_user_server
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )
