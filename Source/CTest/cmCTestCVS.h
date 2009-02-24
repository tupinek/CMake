/*=========================================================================

  Program:   CMake - Cross-Platform Makefile Generator
  Module:    $RCSfile$
  Language:  C++
  Date:      $Date$
  Version:   $Revision$

  Copyright (c) 2002 Kitware, Inc. All rights reserved.
  See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#ifndef cmCTestCVS_h
#define cmCTestCVS_h

#include "cmCTestVC.h"

/** \class cmCTestCVS
 * \brief Interaction with cvs command-line tool
 *
 */
class cmCTestCVS: public cmCTestVC
{
public:
  /** Construct with a CTest instance and update log stream.  */
  cmCTestCVS(cmCTest* ctest, std::ostream& log);

  virtual ~cmCTestCVS();
};

#endif