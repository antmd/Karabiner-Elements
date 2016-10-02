cmake_minimum_required( VERSION 3.2 )

project(dump_hid_report)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(dump_hid_report_INCLUDE_FILES
    )

set(dump_hid_report_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE dump_hid_report
# ---------------
add_executable(dump_hid_report ${dump_hid_report_SOURCE_FILES} ${dump_hid_report_INCLUDE_FILES})


# INSTALL dump_hid_report
# -------
install (
    TARGETS dump_hid_report
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

