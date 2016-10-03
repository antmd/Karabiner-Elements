cmake_minimum_required( VERSION 3.2 )

project(grabber VERSION 0.1.0)

################################
# grabber
################################

# ------
# SOURCE
# ------

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(INCLUDE_FILES
    include/connection_manager.hpp
    include/device_grabber.hpp
    include/logger.hpp
    include/manipulator
    include/manipulator/event_dispatcher_manager.hpp
    include/manipulator/event_manipulator.hpp
    include/manipulator/event_tap_manager.hpp
    include/manipulator/modifier_flag_manager.hpp
    include/manipulator/pointing_button_manager.hpp
    include/manipulator.hpp
    include/receiver.hpp
    )

set(SOURCE_FILES
    main.cpp
    )


find_package(Boost MODULE REQUIRED)

# ----------
# EXECUTABLE
# ----------

add_executable(grabber ${SOURCE_FILES} ${INCLUDE_FILES})

set_target_properties(
    grabber
    PROPERTIES
    OUTPUT_NAME karabiner_grabber
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    )

if (${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(console_user_server PROPERTIES XCODE_ATTRIBUTE_PRODUCT_NAME "karabiner_grabber")
endif()

target_link_libraries(
    grabber
    PRIVATE
    karabiner_shared
    "-framework Foundation"
    "-framework IOKit"
    "-framework Carbon"
    "-framework SystemConfiguration"
    )

target_include_directories(
    grabber 
    PRIVATE
    ${CMAKE_BINARY_DIR}/include
    include
    include/manipulator
    ${Boost_INCLUDE_DIRS}
    ../../vendor
    )

target_compile_options(
    grabber 
    PRIVATE
    -Wno-deprecated-declarations
    )

# -------
# INSTALL
# -------

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Installed)
install (
    TARGETS grabber
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )
