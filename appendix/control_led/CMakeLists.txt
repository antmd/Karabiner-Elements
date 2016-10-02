cmake_minimum_required( VERSION 3.2 )

project(control_led)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(control_led_INCLUDE_FILES
    )

set(control_led_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE control_led
# ---------------
add_executable(control_led ${control_led_SOURCE_FILES} ${control_led_INCLUDE_FILES})


# INSTALL control_led
# -------
install (
    TARGETS control_led
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

