if (SDFormat_CONFIG_INCLUDED)
  return()
endif()
set(SDFormat_CONFIG_INCLUDED TRUE)

list(APPEND SDFormat_INCLUDE_DIRS "/opt/parrot-sphinx/usr/include/sdformat-3.5")

list(APPEND SDFormat_CFLAGS "-I/opt/parrot-sphinx/usr/include/sdformat-3.5")
if (NOT WIN32)
  list(APPEND SDFormat_CXX_FLAGS "${SDFormat_CFLAGS} -std=c++11")
endif()

foreach(lib sdformat)
  set(onelib "${lib}-NOTFOUND")
  find_library(onelib ${lib}
    PATHS "/opt/parrot-sphinx/usr/lib"
    NO_DEFAULT_PATH
    )
  if(NOT onelib)
    message(FATAL_ERROR "Library '${lib}' in package SDFormat is not installed properly")
  endif()
  list(APPEND SDFormat_LIBRARIES "${onelib}")
endforeach()

find_package(ignition-math)
list(APPEND SDFormat_INCLUDE_DIRS ${IGNITION-MATH_INCLUDE_DIRS})
list(APPEND SDFormat_LIBRARIES ${IGNITION-MATH_LIBRARIES})

find_package(Boost)
list(APPEND SDFormat_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
list(APPEND SDFormat_LIBRARIES ${Boost_LIBRARIES})

list(APPEND SDFormat_LDFLAGS "-L/opt/parrot-sphinx/usr/lib")
