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
subdirs(Doxygen KWStyle)

make_directory(${CMake_BINARY_DIR}/Docs)

# Add a documentation target.
set(DOC_FILES "")

set(MAN_FILES
  ${CMake_BINARY_DIR}/Docs/cmake.1
  ${CMake_BINARY_DIR}/Docs/cmakecommands.1
  ${CMake_BINARY_DIR}/Docs/cmakecompat.1
  ${CMake_BINARY_DIR}/Docs/cmakeprops.1
  ${CMake_BINARY_DIR}/Docs/cmakepolicies.1
  ${CMake_BINARY_DIR}/Docs/cmakevars.1
  ${CMake_BINARY_DIR}/Docs/cmakemodules.1
  )
set(TEXT_FILES
  ${CMake_BINARY_DIR}/Docs/cmake.txt
  ${CMake_BINARY_DIR}/Docs/cmake.docbook
  ${CMake_BINARY_DIR}/Docs/cmake-policies.txt
  ${CMake_BINARY_DIR}/Docs/cmake-properties.txt
  ${CMake_BINARY_DIR}/Docs/cmake-variables.txt
  ${CMake_BINARY_DIR}/Docs/cmake-modules.txt
  ${CMake_BINARY_DIR}/Docs/cmake-commands.txt
  ${CMake_BINARY_DIR}/Docs/cmake-compatcommands.txt
  )
set(HTML_FILES
  ${CMake_BINARY_DIR}/Docs/cmake.html
  ${CMake_BINARY_DIR}/Docs/cmake-policies.html
  ${CMake_BINARY_DIR}/Docs/cmake-properties.html
  ${CMake_BINARY_DIR}/Docs/cmake-variables.html
  ${CMake_BINARY_DIR}/Docs/cmake-modules.html
  ${CMake_BINARY_DIR}/Docs/cmake-commands.html
  ${CMake_BINARY_DIR}/Docs/cmake-compatcommands.html
  )

macro(ADD_DOCS target dependency)
  # Generate documentation for "ctest" executable.
  get_target_property(CMD ${target} LOCATION)
  # only generate the documentation if the target is actually built
  if(CMD)
    add_custom_command(
      OUTPUT ${CMake_BINARY_DIR}/Docs/${target}.txt
      ${${target}-PATH} # Possibly set PATH, see below.
      COMMAND ${CMD}
      ARGS --help-full ${CMake_BINARY_DIR}/Docs/${target}.txt
           --help-full ${CMake_BINARY_DIR}/Docs/${target}.html
           --help-full ${CMake_BINARY_DIR}/Docs/${target}.1
           --help-full ${CMake_BINARY_DIR}/Docs/${target}.docbook
      DEPENDS ${target}
      MAIN_DEPENDENCY ${dependency}
      )
    set(DOC_FILES ${DOC_FILES} ${CMake_BINARY_DIR}/Docs/${target}.txt)
    list(APPEND MAN_FILES ${CMake_BINARY_DIR}/Docs/${target}.1)
    list(APPEND TEXT_FILES
      ${CMake_BINARY_DIR}/Docs/${target}.txt
      ${CMake_BINARY_DIR}/Docs/${target}.docbook
      )
    list(APPEND HTML_FILES ${CMake_BINARY_DIR}/Docs/${target}.html)
  endif()
endmacro()

# Help cmake-gui find the Qt DLLs on Windows.
set(WIN_SHELL_GENS "Visual Studio|NMake|MinGW|Watcom|Borland")
if(BUILD_QtDialog AND "${CMAKE_GENERATOR}" MATCHES "${WIN_SHELL_GENS}"
    AND EXISTS "${QT_QMAKE_EXECUTABLE}" AND NOT CMAKE_NO_AUTO_QT_ENV)
  get_filename_component(Qt_BIN_DIR "${QT_QMAKE_EXECUTABLE}" PATH)
  if(EXISTS "${Qt_BIN_DIR}/QtCore4.dll")
    # Tell the macro to set the path before running cmake-gui.
    string(REPLACE ";" "\\;" _PATH "PATH=${Qt_BIN_DIR};%PATH%")
    set(cmake-gui-PATH COMMAND set "${_PATH}")
  endif()
endif(BUILD_QtDialog AND "${CMAKE_GENERATOR}" MATCHES "${WIN_SHELL_GENS}"
  AND EXISTS "${QT_QMAKE_EXECUTABLE}" AND NOT CMAKE_NO_AUTO_QT_ENV)

# add the docs for the executables
ADD_DOCS(ctest      ${CMake_SOURCE_DIR}/Utilities/Doxygen/authors.txt)
ADD_DOCS(cpack      ${CMake_SOURCE_DIR}/Utilities/Doxygen/authors.txt)
ADD_DOCS(ccmake     ${CMake_SOURCE_DIR}/Utilities/Doxygen/authors.txt)
ADD_DOCS(CMakeSetup ${CMake_SOURCE_DIR}/Utilities/Doxygen/doxyfile.in)
ADD_DOCS(cmake-gui ${CMake_SOURCE_DIR}/Utilities/Doxygen/doxyfile.in)

# add the documentation for cmake itself

get_target_property(CMD cmake LOCATION)
add_custom_command(
  OUTPUT ${CMake_BINARY_DIR}/Docs/cmake.txt
  COMMAND ${CMD}
  ARGS --copyright ${CMake_BINARY_DIR}/Docs/Copyright.txt
       --help-full ${CMake_BINARY_DIR}/Docs/cmake.txt
       --help-full ${CMake_BINARY_DIR}/Docs/cmake.html
       --help-full ${CMake_BINARY_DIR}/Docs/cmake.1
       --help-full ${CMake_BINARY_DIR}/Docs/cmake.docbook
       --help-policies ${CMake_BINARY_DIR}/Docs/cmake-policies.txt
       --help-policies ${CMake_BINARY_DIR}/Docs/cmake-policies.html
       --help-policies ${CMake_BINARY_DIR}/Docs/cmakepolicies.1
       --help-properties ${CMake_BINARY_DIR}/Docs/cmake-properties.txt
       --help-properties ${CMake_BINARY_DIR}/Docs/cmake-properties.html
       --help-properties ${CMake_BINARY_DIR}/Docs/cmakeprops.1
       --help-variables ${CMake_BINARY_DIR}/Docs/cmake-variables.txt
       --help-variables ${CMake_BINARY_DIR}/Docs/cmake-variables.html
       --help-variables ${CMake_BINARY_DIR}/Docs/cmakevars.1
       --help-modules ${CMake_BINARY_DIR}/Docs/cmake-modules.txt
       --help-modules ${CMake_BINARY_DIR}/Docs/cmake-modules.html
       --help-modules ${CMake_BINARY_DIR}/Docs/cmakemodules.1
       --help-commands ${CMake_BINARY_DIR}/Docs/cmake-commands.txt
       --help-commands ${CMake_BINARY_DIR}/Docs/cmake-commands.html
       --help-commands ${CMake_BINARY_DIR}/Docs/cmakecommands.1
       --help-compatcommands ${CMake_BINARY_DIR}/Docs/cmake-compatcommands.txt
       --help-compatcommands ${CMake_BINARY_DIR}/Docs/cmake-compatcommands.html
       --help-compatcommands ${CMake_BINARY_DIR}/Docs/cmakecompat.1
  DEPENDS cmake
  MAIN_DEPENDENCY ${CMake_SOURCE_DIR}/Utilities/Doxygen/authors.txt
  )

install_files(${CMAKE_MAN_DIR}/man1 FILES ${MAN_FILES})
install_files(${CMAKE_DOC_DIR} FILES ${HTML_FILES} ${TEXT_FILES})
install(FILES cmake.m4 DESTINATION share/aclocal)

# Drive documentation generation.
add_custom_target(documentation ALL DEPENDS ${DOC_FILES} ${CMake_BINARY_DIR}/Docs/cmake.txt )

# Documentation testing.
if(BUILD_TESTING)
  find_package(LibXml2 QUIET)
  if(NOT DEFINED LIBXML2_XMLLINT_EXECUTABLE)
    find_program(LIBXML2_XMLLINT_EXECUTABLE xmllint)
  endif()
  mark_as_advanced(LIBXML2_XMLLINT_EXECUTABLE)
  if(LIBXML2_XMLLINT_EXECUTABLE)
    execute_process(COMMAND ${LIBXML2_XMLLINT_EXECUTABLE} --help
      OUTPUT_VARIABLE _help ERROR_VARIABLE _err)
    if("${_help}" MATCHES "--path" AND "${_help}" MATCHES "--nonet")
      # We provide the XHTML DTD and its dependencies in the 'xml'
      # directory so that xmllint can run without network access.
      # However, it's --path option accepts a space-separated list of
      # paths so it cannot handle spaces in the path to the source tree.
      # Therefore we run the tool with the current work directory set to
      # the 'xml' directory and use '.' as the path.
      add_test(CMake.HTML
        ${CMAKE_CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_SOURCE_DIR}/xml
        ${LIBXML2_XMLLINT_EXECUTABLE} --valid --noout --nonet --path .
        ${HTML_FILES}
        )
    endif()
  endif()
endif()
