cmake_minimum_required( VERSION 3.2 )

project(dump_system_preferences)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(dump_system_preferences_INCLUDE_FILES
    )

set(dump_system_preferences_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE dump_system_preferences
# ---------------
add_executable(dump_system_preferences ${dump_system_preferences_SOURCE_FILES} ${dump_system_preferences_INCLUDE_FILES})


# INSTALL dump_system_preferences
# -------
install (
    TARGETS dump_system_preferences
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

