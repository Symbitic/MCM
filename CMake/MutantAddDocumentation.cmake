# MutantAddDocumentation
# ======================
#
# Generate documentation for a Mutant Engine project.
#
# mutant_add_documentation
# ------------------------
#
# Generate HTML documentation for a Mutant Engine project.

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

if(_MUTANT_ADD_DOCUMENTATION_DEFINED)
    return()
endif()
set(_MUTANT_ADD_DOCUMENTATION_DEFINED TRUE)

include(${CMAKE_ROOT}/Modules/CMakeParseArguments.cmake)

find_package(Doxygen QUIET)
if(NOT DOXYGEN_FOUND)
    message(SEND_ERROR "Doxygen was not found")
    return()
elseif(DOXYGEN_VERSION VERSION_LESS "1.8.0")
    message(SEND_ERROR "Mutant Engine requires Doxygen 1.8.0 or later.")
    return()
else()
    if(NOT DOXYGEN_DOT_FOUND)
        set(MUTANT_DOT_ENABLED "NO")
        set(MUTANT_DOT_PATH)
    else()
        set(MUTANT_DOT_ENABLED "YES")
        set(MUTANT_DOT_PATH "${DOXYGEN_DOT_EXECUTABLE}")

        set(MUTANT_DOT_MULTI_TARGETS "NO")
        execute_process(
            COMMAND ${DOXYGEN_DOT_EXECUTABLE} -V
            OUTPUT_VARIABLE DOT_VERSION_STR
            ERROR_VARIABLE DOT_VERSION_STR
        )
        if(DOT_VERSION_STR MATCHES "graphviz version ([0-9\\.]+)")
            string(REGEX REPLACE ".*graphviz version ([0-9\\.]+).*" "\\1"
                DOT_VERSION "${DOT_VERSION_STR}")
            if(DOT_VERSION VERSION_GREATER "1.8.10")
                set(MUTANT_DOT_MULTI_TARGETS "YES")
            endif()
        endif()
    endif()
endif()

find_path(MSCGEN_PATH mscgen mscgen.exe)
if(MSCGEN_PATH)
    set(MUTANT_MSCGEN_PATH "${MSCGEN_PATH}")
endif()

find_path(DIA_PATH dia dia.exe)
if(DIA_PATH)
    set(MUTANT_DIA_PATH "${DIA_PATH}")
endif()

set(DOXYGEN_DIR "${CMAKE_CURRENT_LIST_DIR}/doxygen")
set(STATIC_DIR "${DOXYGEN_DIR}/static")

set(DEFAULT_DOXYFILE "${DOXYGEN_DIR}/Doxyfile.in")
set(DEFAULT_DESCRIPTION "A Mutant Engine Project")
set(DEFAULT_STYLESHEET "${DOXYGEN_DIR}/mutant.css")
set(DEFAULT_HTML_HEADER "${DOXYGEN_DIR}/header.html")
set(DEFAULT_HTML_FOOTER "${DOXYGEN_DIR}/footer.html")
set(DEFAULT_LOGO "${DOXYGEN_DIR}/logo.svg")
set(DEFAULT_LAYOUT_FILE "${DOXYGEN_DIR}/DoxygenLayout.xml")

function(MUTANT_ADD_DOCUMENTATION TGT_NAME)
    set(BOOLEANS)
    set(STRINGS "MAIN_PAGE" "DOXYFILE" "VERSION" "DESCRIPTION")
    set(LISTS "SOURCES")
    cmake_parse_arguments(MDOC "${BOOLEANS}" "${STRINGS}" "${LISTS}" ${ARGN})

    list(APPEND MDOC_SOURCES "${MDOC_UNPARSED_ARGUMENTS}")

    if(NOT DEFINED MDOC_DOXYFILE)
        set(MDOC_DOXYFILE "${DEFAULT_DOXYFILE}")
    endif()

    if(NOT EXISTS "${MDOC_DOXYFILE}")
        message(SEND_ERROR "${MDOC_DOXYFILE} does not exist!")
        return()
    endif()

    if(NOT DEFINED MDOC_VERSION)
        if(DEFINED ${TGT_NAME}_VERSION)
            set(MDOC_VERSION "${${TGT_NAME}_VERSION}")
        else()
            set(MDOC_VERSION "0.0.0")
        endif()
    endif()

    if(NOT DEFINED MDOC_DESCRIPTION)
        set(MDOC_DESCRIPTION "${DEFAULT_DESCRIPTION}")
    endif()

    get_filename_component(MDOC_MAIN_PAGE "${MDOC_MAIN_PAGE}" ABSOLUTE)
    set(MDOC_INPUT_FILES "")
    foreach(src ${MDOC_MAIN_PAGE} ${MDOC_SOURCES})
        get_filename_component(src "${src}" ABSOLUTE)
        list(APPEND MDOC_INPUT_FILES "\"${src}\"")
    endforeach()
    string(REPLACE ";" " " MDOC_INPUT_FILES "${MDOC_INPUT_FILES}")
    set(MDOC_MAIN_PAGE "\"${MDOC_MAIN_PAGE}\"")
    set(MDOC_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}")
    file(GLOB_RECURSE MUTANT_EXTRA_FILES "${STATIC_DIR}/*")
    string(REPLACE ";" " " MUTANT_EXTRA_FILES "${MUTANT_EXTRA_FILES}")

    set(MUTANT_PROJECT_NAME "${TGT_NAME}")
    set(MUTANT_DESCRIPTION "A Mutant Engine Project")
    set(MUTANT_OUTPUT_DIR "${MDOC_OUTPUT_DIR}")
    set(MUTANT_MAIN_PAGE "${MDOC_MAIN_PAGE}")
    set(MUTANT_VERSION "${MDOC_VERSION}")
    set(MUTANT_INPUT_FILES "${MDOC_INPUT_FILES}")

    set(MUTANT_HTML_HEADER "${DEFAULT_HTML_HEADER}")
    set(MUTANT_HTML_FOOTER "${DEFAULT_HTML_FOOTER}")
    set(MUTANT_LOGO "${DEFAULT_LOGO}")
    set(MUTANT_STYLESHEET "${DEFAULT_STYLESHEET}")
    set(MUTANT_LAYOUT_FILE "${CMAKE_CURRENT_BINARY_DIR}/DoxygenLayout.xml")

    set(DOXYGEN_LOG "${CMAKE_CURRENT_BINARY_DIR}/DoxygenWarningLog.txt")

    configure_file("${DEFAULT_LAYOUT_FILE}"
        "${CMAKE_CURRENT_BINARY_DIR}/DoxygenLayout.xml")

    configure_file("${MDOC_DOXYFILE}" "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile")

    if(NOT TARGET doc)
        add_custom_target(doc ALL WORKING_DIRECTORY "${MUTANT_OUTPUT_DIR}")
    endif()

    # TODO: DEPENDS, APPEND, VERBATIM
    add_custom_command(OUTPUT "${MUTANT_OUTPUT_DIR}/html"
        COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile"
        WORKING_DIRECTORY "${MUTANT_OUTPUT_DIR}"
        COMMENT "Generating ${TGT_NAME} documentation"
    )

    set_property(TARGET doc APPEND PROPERTY SOURCES "${MUTANT_OUTPUT_DIR}/html")
endfunction()
