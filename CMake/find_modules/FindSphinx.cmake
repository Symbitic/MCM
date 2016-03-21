#.rst:
# FindSphinx
# ----------
#
# Locate Sphinx - The official python documentation generator.
#
# Result Variables
# ~~~~~~~~~~~~~~~~
#
# ``SPHINX_FOUND``
#  Set to ``TRUE`` if Sphinx was found on the users system.
# ``SPHINX_EXECUTABLE``
#  Path to the ``sphinx-build`` python executable.
# ``SPHINX_VERSION``
#  Version of Sphinx detected.

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

if(APPLE)
    # Fink
    list(APPEND SPHINX_PATH_DIRS "/sw")
    # DarwinPorts
    list(APPEND SPHINX_PATH_DIRS "/opt/local")
endif()

if(CMAKE_SYSTEM_NAME MATCHES "(Solaris|SunOS)")
    # BlastWave
    list(APPEND SPHINX_PATH_DIRS "/opt/csw")
endif()

if(UNIX)
    list(APPEND SPHINX_PATH_DIRS "/usr")
    list(APPEND SPHINX_PATH_DIRS "/usr/local")
endif()

find_program(SPHINX_EXECUTABLE
    NAMES sphinx-build sphinx-build.exe sphinx-build.py
    PATHS ${SPHINX_PATH_DIRS}
    PATH_SUFFIXES bin
    DOC "Path to sphinx-build"
)

if(NOT SPHINX_VERSION)
    set(_SPHINX_VERSION "0.0.0")

    if(SPHINX_EXECUTABLE)
        execute_process(
            COMMAND ${SPHINX_EXECUTABLE} --version
            RESULT_VARIABLE result 
            OUTPUT_VARIABLE output 
            ERROR_VARIABLE error 
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        if(${result} EQUAL 0)
            set(REGEX "^Sphinx \\(sphinx-build\\) ([0-9]+\\.[0-9]+\\.[0-9]+)$")
            if("${output}" MATCHES "${REGEX}")
                string(REGEX REPLACE "${REGEX}" "\\1" _SPHINX_VERSION
                    "${output}")
            endif()
        endif()
    endif()

    set(SPHINX_VERSION "${_SPHINX_VERSION}" CACHE STRING "Sphinx version")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sphinx REQUIRED_VARS SPHINX_EXECUTABLE
    VERSION_VAR SPHINX_VERSION)
