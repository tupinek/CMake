#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2009 Kitware, Inc., Insight Software Consortium
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

# If the cmake version includes cpack, use it
if(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
  if(EXISTS "${CMAKE_ROOT}/Modules/InstallRequiredSystemLibraries.cmake")
    option(CMAKE_INSTALL_DEBUG_LIBRARIES
      "Install Microsoft runtime debug libraries with CMake." FALSE)
    mark_as_advanced(CMAKE_INSTALL_DEBUG_LIBRARIES)

    # By default, do not warn when built on machines using only VS Express:
    if(NOT DEFINED CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS)
      set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS ON)
    endif()

    include(${CMake_SOURCE_DIR}/Modules/InstallRequiredSystemLibraries.cmake)
  endif()

  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "CMake is a build tool")
  set(CPACK_PACKAGE_VENDOR "Kitware")
  set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
  set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
  set(CPACK_PACKAGE_VERSION "${CMake_VERSION}")
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${CMake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")
  set(CPACK_SOURCE_PACKAGE_FILE_NAME "cmake-${CMake_VERSION}")

  # Make this explicit here, rather than accepting the CPack default value,
  # so we can refer to it:
  set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")

  # Installers for 32- vs. 64-bit CMake:
  #  - Root install directory (displayed to end user at installer-run time)
  #  - "NSIS package/display name" (text used in the installer GUI)
  #  - Registry key used to store info about the installation
  if(CMAKE_CL_64)
    set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
    set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} (Win64)")
    set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME} ${CPACK_PACKAGE_VERSION} (Win64)")
  else()
    set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
    set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
    set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME} ${CPACK_PACKAGE_VERSION}")
  endif()

  if(NOT DEFINED CPACK_SYSTEM_NAME)
    # make sure package is not Cygwin-unknown, for Cygwin just
    # cygwin is good for the system name
    if("${CMAKE_SYSTEM_NAME}" STREQUAL "CYGWIN")
      set(CPACK_SYSTEM_NAME Cygwin)
    else()
      set(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})
    endif()
  endif()
  if(${CPACK_SYSTEM_NAME} MATCHES Windows)
    if(CMAKE_CL_64)
      set(CPACK_SYSTEM_NAME win64-x64)
    else()
      set(CPACK_SYSTEM_NAME win32-x86)
    endif()
  endif()

  if(NOT DEFINED CPACK_PACKAGE_FILE_NAME)
    # if the CPACK_PACKAGE_FILE_NAME is not defined by the cache
    # default to source package - system, on cygwin system is not
    # needed
    if(CYGWIN)
      set(CPACK_PACKAGE_FILE_NAME "${CPACK_SOURCE_PACKAGE_FILE_NAME}")
    else()
      set(CPACK_PACKAGE_FILE_NAME
        "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
    endif()
  endif()

  set(CPACK_PACKAGE_CONTACT "cmake@cmake.org")

  if(UNIX)
    set(CPACK_STRIP_FILES "bin/ccmake;bin/cmake;bin/cpack;bin/ctest")
    set(CPACK_SOURCE_STRIP_FILES "")
    set(CPACK_PACKAGE_EXECUTABLES "ccmake" "CMake")
  endif()

  # cygwin specific packaging stuff
  if(CYGWIN)
    # setup the cygwin package name
    set(CPACK_PACKAGE_NAME cmake)
    # setup the name of the package for cygwin cmake-2.4.3
    set(CPACK_PACKAGE_FILE_NAME
      "${CPACK_PACKAGE_NAME}-${CMake_VERSION}")
    # the source has the same name as the binary
    set(CPACK_SOURCE_PACKAGE_FILE_NAME ${CPACK_PACKAGE_FILE_NAME})
    # Create a cygwin version number in case there are changes for cygwin
    # that are not reflected upstream in CMake
    set(CPACK_CYGWIN_PATCH_NUMBER 1)
    # These files are required by the cmCPackCygwinSourceGenerator and the files
    # put into the release tar files.
    set(CPACK_CYGWIN_BUILD_SCRIPT
      "${CMake_BINARY_DIR}/@CPACK_PACKAGE_FILE_NAME@-@CPACK_CYGWIN_PATCH_NUMBER@.sh")
    set(CPACK_CYGWIN_PATCH_FILE
      "${CMake_BINARY_DIR}/@CPACK_PACKAGE_FILE_NAME@-@CPACK_CYGWIN_PATCH_NUMBER@.patch")
    # include the sub directory cmake file for cygwin that
    # configures some files and adds some install targets
    # this file uses some of the package file name variables
    include(Utilities/Release/Cygwin/CMakeLists.txt)
  endif()

  # Set the options file that needs to be included inside CMakeCPackOptions.cmake
  set(QT_DIALOG_CPACK_OPTIONS_FILE ${CMake_BINARY_DIR}/Source/QtDialog/QtDialogCPack.cmake)
  configure_file("${CMake_SOURCE_DIR}/CMakeCPackOptions.cmake.in"
    "${CMake_BINARY_DIR}/CMakeCPackOptions.cmake" @ONLY)
  set(CPACK_PROJECT_CONFIG_FILE "${CMake_BINARY_DIR}/CMakeCPackOptions.cmake")

  # include CPack model once all variables are set
  include(CPack)
endif()
