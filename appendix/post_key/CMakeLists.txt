cmake_minimum_required( VERSION 3.2 )

project(post_key)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(post_key_INCLUDE_FILES
    )

set(post_key_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE post_key
# ---------------
add_executable(post_key ${post_key_SOURCE_FILES} ${post_key_INCLUDE_FILES})


# INSTALL post_key
# -------
install (
    TARGETS post_key
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

