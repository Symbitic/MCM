#.rst:
# CMakeInstallLibdir
# ------------------
#
# Define the variable ``CMAKE_INSTALL_LIBDIR`` (if not already set).

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

if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
    set(LIBDIR "lib")

    if(CMAKE_SYSTEM_NAME MATCHES "^(Linux|kFreeBSD|GNU)$")
        if(NOT CMAKE_CROSSCOMPILING)
            if(EXISTS "/etc/debian_version")
                if(CMAKE_LIBRARY_ARCHITECTURE)
                    set(LIBDIR "lib/${CMAKE_LIBRARY_ARCHITECTURE}")
                endif()
            else()
                if(CMAKE_SIZEOF_VOID_P AND "${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
                    set(LIBDIR "lib64")
                endif()
            endif()
        endif()
    endif()

    set(CMAKE_INSTALL_LIBDIR "${LIBDIR}" CACHE INTERNAL
        "Library install subdirectory.")
endif()
