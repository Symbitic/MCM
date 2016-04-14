#.rst:
# MutantSetupVersion
# ------------------
#
# Handle library version information. ::
#
#   mutant_setup_version(<version>
#     VARIABLE_PREFIX <prefix>
#     [SOVERSION <soversion>]
#     [PACKAGE_VERSION_FILE <filename>]
#   )
#
# Parse a version string and setup a set of version variables. Optionally, also
# creates a CMake package version file.
#
# .. TODO:: Add more documentation from ECMSetupVersion.cmake
#

################################################################################
# Copyright (c) 2015-2016 Mutant Engine Contributors.
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

if(_MUTANT_SETUP_VERSION_DEFINED)
    return()
endif()
set(_MUTANT_SETUP_VERSION_DEFINED TRUE)

# Import ``write_basic_package_version_file()``
include(${CMAKE_ROOT}/Modules/CMakePackageConfigHelpers.cmake)

function(MUTANT_SETUP_VERSION _version)
    set(BOOLEAN_ARGS)
    set(SINGLE_ARGS "VARIABLE_PREFIX;SOVERSION;PACKAGE_VERSION_FILE")
    set(MULTI_ARGS)

    cmake_parse_arguments(MSV "${BOOLEAN_ARGS}" "${SINGLE_ARGS}" "${MULTI_ARGS}"
        ${ARGN})

    if(MSV_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to MUTANT_SETUP_VERSION(): "
            "\"${MSV_UNPARSED_ARGUMENTS}\"")
    endif()

    if(CMAKE_VERSION VERSION_LESS 3.0.0)
        message(FATAL_ERROR
            "MUTANT_SETUP_VERSION() requires CMake 3.0.0 or later.")
    endif()

    string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" _major
        "${_version}")
    string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" _minor
        "${_version}")
    string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" _patch
        "${_version}")

    if(MSV_VARIABLE_PREFIX)
        set(${MSV_VARIABLE_PREFIX}_VERSION "${_version}" PARENT_SCOPE)
        set(${MSV_VARIABLE_PREFIX}_VERSION_MAJOR ${_major} PARENT_SCOPE)
        set(${MSV_VARIABLE_PREFIX}_VERSION_MINOR ${_minor} PARENT_SCOPE)
        set(${MSV_VARIABLE_PREFIX}_VERSION_PATCH ${_patch} PARENT_SCOPE)
    endif()

    if(MSV_PACKAGE_VERSION_FILE)
        if(NOT MSV_COMPATIBILITY)
            set(MSV_COMPATIBILITY AnyNewerVersion)
        endif()
        write_basic_package_version_file("${MSV_PACKAGE_VERSION_FILE}"
            VERSION ${_version} COMPATIBILITY ${MSV_COMPATIBILITY})
    endif()


endfunction()

