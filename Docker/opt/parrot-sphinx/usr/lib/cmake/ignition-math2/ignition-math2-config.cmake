if (IGNITION-MATH_CONFIG_INCLUDED)
  return()
endif()
set(IGNITION-MATH_CONFIG_INCLUDED TRUE)

list(APPEND IGNITION-MATH_INCLUDE_DIRS "/opt/parrot-sphinx/usr/include/ignition/math2")

list(APPEND IGNITION-MATH_LIBRARY_DIRS "/opt/parrot-sphinx/usr/lib")

list(APPEND IGNITION-MATH_CXX_FLAGS -std=c++11)
if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
  set(IGNITION-MATH_CXX_FLAGS "${IGNITION-MATH_CXX_FLAGS} -stdlib=libc++")
endif ()

# On windows we produce .dll libraries with no prefix
if (WIN32)
 set(CMAKE_FIND_LIBRARY_PREFIXES "")
 set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")
endif()

foreach(lib ignition-math2)
  set(onelib "${lib}-NOTFOUND")
  find_library(onelib ${lib}
    PATHS "/opt/parrot-sphinx/usr/lib"
    NO_DEFAULT_PATH
    )
  if(NOT onelib)
    message(FATAL_ERROR "Library '${lib}' in package IGNITION-MATH is not installed properly")
  endif()
  list(APPEND IGNITION-MATH_LIBRARIES ${onelib})
endforeach()

foreach(dep )
  if(NOT ${dep}_FOUND)
    find_package(${dep} REQUIRED)
  endif()
  list(APPEND IGNITION-MATH_INCLUDE_DIRS "${${dep}_INCLUDE_DIRS}")
  list(APPEND IGNITION-MATH_LIBRARIES "${${dep_lib}_LIBRARIES}")
endforeach()

list(APPEND IGNITION-MATH_LDFLAGS "-L/opt/parrot-sphinx/usr/lib")
