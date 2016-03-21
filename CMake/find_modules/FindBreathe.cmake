#.rst:
# FindBreathe
# -----------
#
# Find Breathe - a Python module for integrating Doxygen documentation into
# Sphinx.
#
# Installing Breathe
# ~~~~~~~~~~~~~~~~~~
#
# If breathe is not already installed, you can install it by running the
# following:
#
# .. code-block:: bash
#
#    sudo pip install breathe
#
# Result Variables
# ~~~~~~~~~~~~~~~~
#
# ``BREATHE_FOUND``
#  Set to ``TRUE`` if Breathe was found and can be used by Sphinx.
# ``BREATHE_VERSION``
#  Version of Breathe detected.
# ``BREATHE_ROOT``
#  Path to where Breathe is installed

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
    list(APPEND PIP_PATH_DIRS "/sw")
    # DarwinPorts
    list(APPEND PIP_PATH_DIRS "/opt/local")
endif()

if(CMAKE_SYSTEM_NAME MATCHES "(Solaris|SunOS)")
    # BlastWave
    list(APPEND PIP_PATH_DIRS "/opt/csw")
endif()

if(UNIX)
    list(APPEND PIP_PATH_DIRS "/usr")
    list(APPEND PIP_PATH_DIRS "/usr/local")
endif()

find_program(PIP_EXECUTABLE
    NAMES pip pip.exe pip.py pip3
    PATHS ${SPHINX_PATH_DIRS}
    PATH_SUFFIXES bin
    DOC "Path to python pip"
)

if(PIP_EXECUTABLE)
    execute_process(
        COMMAND ${PIP_EXECUTABLE} show breathe
        RESULT_VARIABLE result
        OUTPUT_VARIABLE output
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(result EQUAL 0)
        string(REGEX REPLACE "^.*Location: ([A-Za-z0-9/]+).*$" "\\1"
            BREATHE_ROOT "${output}")
        string(REGEX REPLACE "^.*Version: ([A-Za-z0-9\\.]+).*$" "\\1"
            BREATHE_VERSION "${output}")
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Breathe REQUIRED_VARS BREATHE_ROOT
    VERSION_VAR BREATHE_VERSION)
