#.rst:
# CMakePackageConfigure
# ---------------------
#
# CMake helper commands for creating relocatable CONFIG-mode packages to
# use with :command:`find_package`.
#
# Generating a Package Configuration File
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: cmake_package_configure
#
#  Create a config file for a project. ::
#
#    cmake_package_configure(<package>
#      INPUT_NAME <input>
#      OUTPUT_NAME <output>
#      [VERSION <major.minor.patch>]
#      [VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>]
#      [PATH_VARS <var1> <var2> ... <varN>]
#      [NO_SET_AND_CHECK_MACRO]
#      [NO_CHECK_REQUIRED_COMPONENTS_MACRO]
#      [INSTALL_PREFIX <path>]
#    )
#
# When used in place of :command:`configure_file()` for generating
# ``CONFIG``-mode packages, ``cmake_package_configure()`` helps making the
# resulting CMake package relocatable by avoiding hardcoded paths in the
# installed files.
#
# Example Usage
# ^^^^^^^^^^^^^
#
# An example of using :command:`cmake_package_configure`.
#
# ``CMakeLists.txt``:
#
# .. code-block:: cmake
#
#    set(INCLUDE_INSTALL_DIR include/ ... CACHE )
#    set(LIB_INSTALL_DIR lib/ ... CACHE )
#    set(SYSCONFIG_INSTALL_DIR etc/foo/ ... CACHE )
#    ...
#    include(CMakePackageConfigure)
#    cmake_package_configure(
#      INPUT_NAME FooConfig.cmake.in
#      OUTPUT_NAME FooConfig.cmake
#      PATH_VARS INCLUDE_INSTALL_DIR SYSCONFIG_INSTALL_DIR
#      VERSION 1.2.3
#      VERSION_COMPATIBILITY SameMajorVersion
#    )
#
# ``FooConfig.cmake.in``:
#
# .. code-block:: cmake
#
#    set(FOO_VERSION x.y.z)
#    ...
#    @PACKAGE_INIT@
#    ...
#    set_and_check(FOO_INCLUDE_DIR "@PACKAGE_INCLUDE_INSTALL_DIR@")
#    set_and_check(FOO_SYSCONFIG_DIR "@PACKAGE_SYSCONFIG_INSTALL_DIR@")
#
#    check_required_components(Foo)

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

include(${CMAKE_ROOT}/Modules/CMakeParseArguments.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/CMakeInstallLibdir.cmake)

function(CMAKE_PACKAGE_CONFIGURE pkg)
    set(BOOLS NO_SET_AND_CHECK_MACRO NO_CHECK_REQUIRED_COMPONENTS_MACRO)
    set(SINGLES INPUT_NAME OUTPUT_NAME INSTALL_PREFIX VERSION
        VERSION_COMPATIBILITY)
    set(VARIABLES PATH_VARS)

    cmake_parse_arguments(_CONF "${BOOLS}" "${SINGLES}" "${VARIABLES}"  ${ARGN})

    set(INPUT_FILE "${_CONF_INPUT_NAME}")
    set(OUTPUT_FILE "${_CONF_OUTPUT_NAME}")

    if(_CONF_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Unknown keywords given to CMAKE_PACKAGE_CONFIGURE(): "
            "\"${_CONF_UNPARSED_ARGUMENTS}\"")
    elseif("${INPUT_FILE}" STREQUAL "")
        message(FATAL_ERROR "No input file given to CMAKE_PACKAGE_CONFIGURE()")
    elseif("${OUTPUT_FILE}" STREQUAL "")
        message(FATAL_ERROR "No output file given to CMAKE_PACKAGE_CONFIGURE()")
    endif()

    if(WIN32)
        set(_CONF_INSTALL_DESTINATION "CMake")
    else()
        set(_CONF_INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${pkg}")
    endif()

    if(DEFINED _CONF_INSTALL_PREFIX)
        if(IS_ABSOLUTE "${_CONF_INSTALL_PREFIX}")
            set(installPrefix "${_CONF_INSTALL_PREFIX}")
        else()
            message(FATAL_ERROR
                "Relative INSTALL_PREFIX path given to "
                "CMAKE_PACKAGE_CONFIGURE()")
        endif()
    else()
        set(installPrefix "${CMAKE_INSTALL_PREFIX}")
    endif()

    if(IS_ABSOLUTE "${_CONF_INSTALL_DESTINATION}")
        set(absInstallDir "${_CONF_INSTALL_DESTINATION}")
    else()
        set(absInstallDir "${installPrefix}/${_CONF_INSTALL_DESTINATION}")
    endif()

    file(RELATIVE_PATH PACKAGE_RELATIVE_PATH "${absInstallDir}"
        "${installPrefix}")

    foreach(var ${_CONF_PATH_VARS})
        if(NOT DEFINED ${var})
            message(FATAL_ERROR "Variable ${var} does not exist")
        else()
            if(IS_ABSOLUTE "${${var}}")
                string(REPLACE "${installPrefix}" "\${PACKAGE_PREFIX_DIR}"
                    PACKAGE_${var} "${${var}}")
            else()
                set(PACKAGE_${var} "\${PACKAGE_PREFIX_DIR}/${${var}}")
            endif()
        endif()
    endforeach()

    get_filename_component(inputFileName "${INPUT_FILE}" NAME)

    set(PACKAGE_INIT "
###### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
###### Any changes to this file will be overwritten                    #######
###### The input file was ${inputFileName}                             #######

get_filename_component(PACKAGE_PREFIX_DIR \"\${CMAKE_CURRENT_LIST_DIR}/${PACKAGE_RELATIVE_PATH}\" ABSOLUTE)
")

  if("${absInstallDir}" MATCHES "^(/usr)?/lib(64)?/.+")
    # Handle "/usr move" symlinks created by some Linux distros.
    set(PACKAGE_INIT "${PACKAGE_INIT}
# Use original install prefix when loaded through a \"/usr move\"
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr \"\${CMAKE_CURRENT_LIST_DIR}\" REALPATH)
get_filename_component(_realOrig \"${absInstallDir}\" REALPATH)
if(_realCurr STREQUAL _realOrig)
  set(PACKAGE_PREFIX_DIR \"${installPrefix}\")
endif()
unset(_realOrig)
unset(_realCurr)
")
  endif()

  if(NOT _CONF_NO_SET_AND_CHECK_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(set_and_check _var _file)
  set(\${_var} \"\${_file}\")
  if(NOT EXISTS \"\${_file}\")
    message(FATAL_ERROR \"File or directory \${_file} referenced by variable \${_var} does not exist !\")
  endif()
endmacro()
")
  endif()


  if(NOT _CONF_NO_CHECK_REQUIRED_COMPONENTS_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(check_required_components _NAME)
  foreach(comp \${\${_NAME}_FIND_COMPONENTS})
    if(NOT \${_NAME}_\${comp}_FOUND)
      if(\${_NAME}_FIND_REQUIRED_\${comp})
        set(\${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()
")
  endif()

  set(PACKAGE_INIT "${PACKAGE_INIT}
####################################################################################")

  if(NOT IS_ABSOLUTE "${INPUT_FILE}")
    set(INPUT_FILEPATH "${CMAKE_CURRENT_SOURCE_DIR}/${INPUT_FILE}")
  else()
    set(INPUT_FILEPATH "${INPUT_FILE}")
  endif()

  if(NOT IS_ABSOLUTE "${OUTPUT_FILE}")
    set(OUTPUT_FILEPATH "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE}")
  else()
    set(OUTPUT_FILEPATH "${OUTPUT_FILE}")
  endif()

  configure_file("${INPUT_FILEPATH}" "${OUTPUT_FILEPATH}" @ONLY)

  get_filename_component(OUTPUT_PATH "${OUTPUT_FILEPATH}" DIRECTORY)

  if(NOT "${_CONF_VERSION}" STREQUAL "")
    set(VERSION_ROOT "${CMAKE_ROOT}/Modules/BasicConfigVersion")
    set(VERSION_FILE "${VERSION_ROOT}-${_CONF_VERSION_COMPATIBILITY}.cmake.in")
    set(VERSION_OUTPUT "${OUTPUT_PATH}/${pkg}ConfigVersion.cmake")
    set(CVF_VERSION ${_CONF_VERSION})
    if(NOT EXISTS "${VERSION_FILE}")
      set(_ERR "Bad VERSION_COMPATIBILITY value used for ")
      set(_ERR "${_ERR}CMAKE_PACKAGE_CONFIGURE(): \"${_CONF_COMPATIBILITY}\"")
      message(FATAL_ERROR "${_ERR}")
    endif()

    configure_file("${VERSION_FILE}" "${VERSION_OUTPUT}" @ONLY)
  endif()

endfunction()
