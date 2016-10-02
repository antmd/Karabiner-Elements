cmake_minimum_required( VERSION 3.2 )

project(log_monitor)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(log_monitor_INCLUDE_FILES
    )

set(log_monitor_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE log_monitor
# ---------------
add_executable(log_monitor ${log_monitor_SOURCE_FILES} ${log_monitor_INCLUDE_FILES})


# INSTALL log_monitor
# -------
install (
    TARGETS log_monitor
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

