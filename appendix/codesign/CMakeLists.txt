cmake_minimum_required( VERSION 3.2 )

project(codesign)

set(CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/installed)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(codesign_INCLUDE_FILES
    )

set(codesign_SOURCE_FILES
    main.cpp
    )


# EXECUTABLE codesign
# ---------------
add_executable(codesign ${codesign_SOURCE_FILES} ${codesign_INCLUDE_FILES})


# INSTALL codesign
# -------
install (
    TARGETS codesign
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

