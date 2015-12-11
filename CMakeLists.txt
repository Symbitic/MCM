################################################################################
# Copyright (c) 2015 Mutant Engine Contributors.
#
# This file is part of MCM.
#
# MCM is free software; you can redistribute it and/or modify it under the
# terms of version 3 of the GNU General Public License, as published by the
# Free Software Foundation.
#
# In addition to the permissions in the GNU General Public License, the authors
# give you unlimited permission to link the compiled version of MCM into
# combinations with other programs, and to distribute those combinations
# without any restriction coming from the use of MCM. The restrictions of the
# GNU General Public License still apply in other respects.
#
# MCM is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# MCM. If not, see <http://www.gnu.org/licenses/>.
################################################################################

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
cmake_policy(SET CMP0048 NEW)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake;${CMAKE_MODULE_PATH}")
set(CMAKE_BUILD_TYPE_INIT "Debug")

include(CMakePackageConfigHelpers)

project(MCM LANGUAGES NONE VERSION 0.0.1)

if(WIN32)
    set(CMAKECONFIG_INSTALL_DIR "MCM/CMake")
else()
    set(SHARE_INSTALL_DIR share CACHE PATH
        "read-only architecture-independent data")
    mark_as_advanced(SHARE_INSTALL_DIR)

    set(CMAKECONFIG_INSTALL_DIR "${SHARE_INSTALL_DIR}/MCM")
endif()

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/CMake/cmake_modules
    DESTINATION ${CMAKECONFIG_INSTALL_DIR})
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/CMake/find_modules
    DESTINATION ${CMAKECONFIG_INSTALL_DIR})
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/CMake/mutant_modules
    DESTINATION ${CMAKECONFIG_INSTALL_DIR})

configure_package_config_file(MCMConfig.cmake.in MCMConfig.cmake
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR})

write_basic_package_version_file(MCMConfigVersion.cmake
    VERSION ${PROJECT_VERSION} COMPATIBILITY AnyNewerVersion)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/MCMConfig.cmake
    DESTINATION ${CMAKECONFIG_INSTALL_DIR})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/MCMConfigVersion.cmake
    DESTINATION ${CMAKECONFIG_INSTALL_DIR})
