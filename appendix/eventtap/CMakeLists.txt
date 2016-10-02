cmake_minimum_required( VERSION 3.2 )

project(eventtap)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(eventtap_INCLUDE_FILES
    )

set(eventtap_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE eventtap
# ---------------
add_executable(eventtap ${eventtap_SOURCE_FILES} ${eventtap_INCLUDE_FILES})


# INSTALL eventtap
# -------
install (
    TARGETS eventtap
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

