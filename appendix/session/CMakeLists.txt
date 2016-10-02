cmake_minimum_required( VERSION 3.2 )

project(session)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(session_INCLUDE_FILES
    )

set(session_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE session
# ---------------
add_executable(session ${session_SOURCE_FILES} ${session_INCLUDE_FILES})


# INSTALL session
# -------
install (
    TARGETS session
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

