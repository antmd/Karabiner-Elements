cmake_minimum_required( VERSION 3.2 )

project(cg_post_event)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(cg_post_event_INCLUDE_FILES
    )

set(cg_post_event_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE cg_post_event
# ---------------
add_executable(cg_post_event ${cg_post_event_SOURCE_FILES} ${cg_post_event_INCLUDE_FILES})


# INSTALL cg_post_event
# -------
install (
    TARGETS cg_post_event
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

