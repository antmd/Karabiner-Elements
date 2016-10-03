cmake_minimum_required( VERSION 3.2 )

project(shared VERSION 0.1.0)

file(STRINGS ../../version VERSION LIMIT_COUNT 1)

configure_file(karabiner_version.h.in ${CMAKE_BINARY_DIR}/include/karabiner_version.h)

add_library(karabiner_shared INTERFACE)

target_include_directories(
    karabiner_shared 
    INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

target_sources(
    karabiner_shared
    INTERFACE
    ${CMAKE_BINARY_DIR}/include/karabiner_version.h
    ${CMAKE_CURRENT_SOURCE_DIR}/apple_hid_usage_tables.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/boost_defs.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/codesign.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/configuration_core.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/constants.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/file_monitor.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/filesystem.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/grabber_client.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/hid_system_client.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/human_interface_device.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/iokit_utility.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/local_datagram_client.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/local_datagram_server.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/log_monitor.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/notification_center.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/process_monitor.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/service_observer.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/session.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/spdlog_utility.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/system_preferences.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/system_preferences_monitor.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/types.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/virtual_hid_manager_client.hpp
    )

set_source_files_properties(
    karabiner_version.h
    PROPERTIES
    GENERATED 1
    )
