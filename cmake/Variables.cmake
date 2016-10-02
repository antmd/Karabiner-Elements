
if (NOT VariablesSet)
set(CompanyName "com.pqrs" CACHE STRING "Reverse DNS Company Name")
set(CopyrightString "Copyright 2016 pqrs. All Rights Reserved.")
set(FixupBundleTemplate ${CMAKE_CURRENT_LIST_DIR}/FixupBundle.cmake.in CACHE STRING "")
set(VariablesSet 1 CACHE BOOL "")
mark_as_advanced(FixupBundleTemplate VariablesSet)
endif()
