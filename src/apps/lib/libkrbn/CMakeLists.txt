cmake_minimum_required( VERSION 3.2 )

project(libkrbn)

set(CXX_STANDARD 14)
set(CXX_STANDARD_REQUIRED ON)

find_package(Boost REQUIRED)

set(libkrbn_INCLUDE_FILES
    libkrbn.h
    )

set(libkrbn_SOURCE_FILES
    libkrbn.cpp
    )


# EXECUTABLE libkrbn
# ---------------
add_library(${PROJECT_NAME} ${libkrbn_SOURCE_FILES} ${libkrbn_INCLUDE_FILES})

target_include_directories(
    ${PROJECT_NAME} 
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    PRIVATE
    ../../../vendor
    ${Boost_INCLUDE_DIRS}
    )

target_compile_options(
    ${PROJECT_NAME}
    PRIVATE
    -std=c++14
    -stdlib=libc++
    )

# INSTALL libkrbn
# -------
install (
    TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

