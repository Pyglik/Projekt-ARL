if (GAZEBO_CONFIG_INCLUDED)
  return()
endif()
set(GAZEBO_CONFIG_INCLUDED TRUE)
set(GAZEBO_VERSION 7.0)

set(GAZEBO_PLUGIN_PATH "/opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins")

# The media path contains the location on disk where images,
# materials scripts, shaders, and other related resources are stored.
set(GAZEBO_MEDIA_PATH "/opt/parrot-sphinx/usr/share/gazebo-7.0/media")

#################################################
# GAZEBO_PROTO_PATH, GAZEBO_PROTO_INCLUDE_DIRS, and
# GAZEBO_PROTO_LIBRARIES
#
# These three variables allow Gazebo messages to be used in other projects.
#
# The following examples are for demonstration purposes and are
# incomplete. The first example shows how to use a Gazebo message in a
# custom  proto file. The second example shows how to run 'protoc' against
# custom proto files that make use Gazebo message definitions. The third
# example shows how to include the correct directory when compiling a library
# or executable that uses your custom messages.
#
# 1. Use a Gazebo message in a custom proto file:
#
# package my.msgs;
# import "vector3d.proto";
# 
# message MyMessage
# {
#   required gazebo.msgs.Vector3d p = 1;
# }
#
# 2. Run protoc from a CMakeLists.txt to generate your message's
#    header and source files:
#
#  add_custom_command(
#    OUTPUT
#      "${proto_filename}.pb.cc"
#      "${proto_filename}.pb.h"
#    COMMAND protoc
#    ARGS --proto_path ${GAZEBO_PROTO_PATH} ${proto_file_out}
#    COMMENT "Running C++ protocol buffer compiler on ${proto_filename}"
#    VERBATIM)
#
# 3. When compiling your library or executable, make sure to use the following
#    in the CMakeLists.txt file:
#
# include_directories(GAZEBO_PROTO_INCLUDE_DIRS)
# target_link_libraries(your_package GAZEBO_PROTO_LIBRARIES)
#
set(GAZEBO_PROTO_PATH
  "/opt/parrot-sphinx/usr/include/gazebo-7.0/gazebo/msgs/proto")
find_library(gazebo_proto_msgs_lib gazebo_msgs
  PATHS "/opt/parrot-sphinx/usr/lib" NO_DEFAULT_PATH)
list(APPEND GAZEBO_PROTO_LIBRARIES ${gazebo_proto_msgs_lib})
list(APPEND GAZEBO_PROTO_INCLUDE_DIRS
  "/opt/parrot-sphinx/usr/include/gazebo-7.0/gazebo/msgs")
# End GAZEBO_PROTO_PATH, GAZEBO_PROTO_INCLUDE_DIRS, and
# GAZEBO_PROTO_LIBRARIES

list(APPEND GAZEBO_INCLUDE_DIRS /opt/parrot-sphinx/usr/include)
list(APPEND GAZEBO_INCLUDE_DIRS /opt/parrot-sphinx/usr/include/gazebo-7.0)

list(APPEND GAZEBO_LIBRARY_DIRS /opt/parrot-sphinx/usr/lib)
list(APPEND GAZEBO_LIBRARY_DIRS /opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins)

list(APPEND GAZEBO_CFLAGS -I/opt/parrot-sphinx/usr/include)
list(APPEND GAZEBO_CFLAGS -I/opt/parrot-sphinx/usr/include/gazebo-7.0)

# Visual Studio enables c++11 support by default
if (NOT MSVC)
  list(APPEND GAZEBO_CXX_FLAGS -std=c++11)
endif()
if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND
    "${CMAKE_SYSTEM_NAME}" MATCHES "Darwin")
  set(GAZEBO_CXX_FLAGS "${GAZEBO_CXX_FLAGS} -stdlib=libc++")
endif ()

foreach(lib gazebo;gazebo_client;gazebo_gui;gazebo_sensors;gazebo_rendering;gazebo_physics;gazebo_ode;gazebo_transport;gazebo_msgs;gazebo_util;gazebo_common;gazebo_gimpact;gazebo_opcode;gazebo_opende_ou;gazebo_math;gazebo_ccd)
  set(onelib "${lib}-NOTFOUND")
  find_library(onelib ${lib}
    PATHS /opt/parrot-sphinx/usr/lib
    NO_DEFAULT_PATH
    )
  if(NOT onelib)
    message(FATAL_ERROR "Library '${lib}' in package GAZEBO is not installed properly")
  endif()
  list(APPEND GAZEBO_LIBRARIES ${onelib})
endforeach()

# Get the install prefix for OGRE
execute_process(COMMAND pkg-config --variable=prefix OGRE
  OUTPUT_VARIABLE OGRE_INSTALL_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)

# Add the OGRE cmake path to CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH
  "${OGRE_INSTALL_PREFIX}/share/OGRE/cmake/modules;${OGRE_INSTALL_PREFIX}/lib/OGRE/cmake;${OGRE_INSTALL_PREFIX}/CMake;${CMAKE_MODULE_PATH}")

foreach(dep Boost;Protobuf;SDFormat;OGRE)
  if(NOT ${dep}_FOUND)
    if (${dep} MATCHES "Boost")
      find_package(Boost 1.40.0 REQUIRED thread signals system filesystem program_options regex iostreams date_time)
    else()
      find_package(${dep} REQUIRED)
    endif()
  endif()
  list(APPEND GAZEBO_INCLUDE_DIRS ${${dep}_INCLUDE_DIRS})

  # Protobuf needs to be capitalized to match PROTOBUF_LIBRARIES
  if (${dep} STREQUAL "Protobuf")
    string (TOUPPER ${dep} dep_lib)
  else()
    set (dep_lib ${dep})
  endif()

  list(APPEND GAZEBO_LIBRARIES ${${dep_lib}_LIBRARIES})

  # When including OGRE, also include the Terrain and Paging components
  if (${dep} STREQUAL "OGRE")
    list(APPEND GAZEBO_INCLUDE_DIRS ${OGRE_Terrain_INCLUDE_DIRS}
      ${OGRE_Paging_INCLUDE_DIRS})
    list(APPEND GAZEBO_LIBRARIES ${OGRE_Terrain_LIBRARIES}
      ${OGRE_Paging_LIBRARIES})
  endif()
endforeach()

find_package(ignition-math2 REQUIRED)
list(APPEND GAZEBO_INCLUDE_DIRS ${IGNITION-MATH_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARY_DIRS ${IGNITION-MATH_LIBRARY_DIRS})
list(APPEND GAZEBO_LIBRARIES ${IGNITION-MATH_LIBRARIES})

list(APPEND GAZEBO_LDFLAGS -Wl,-rpath,/opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins)
list(APPEND GAZEBO_LDFLAGS -L/opt/parrot-sphinx/usr/lib)
list(APPEND GAZEBO_LDFLAGS -L/opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins)
