cmake_minimum_required( VERSION 3.2 )

project(Karabiner-Elements)

include("cmake/Variables.cmake")

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/Installed)

add_subdirectory(src)
#add_subdirectory(appendix)

