#########################################################################
## NOTE: Do not invoke this cmake yourself, use pip install . (see the ##
## README.md file).                                                    ##
#########################################################################

cmake_minimum_required(VERSION 3.16.3)

project(_pyfri)

include(FetchContent)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(FRI_BUILD_EXAMPLES OFF)

# set the FRI version
set(FRI_CLIENT_VERSION_MAJOR 1 CACHE STRING "The FRI client major version." FORCE)
set(FRI_CLIENT_VERSION_MINOR 15 CACHE STRING "The FRI client minor version." FORCE)

# Patch the FRI SDK to build FRIClient as STATIC instead of SHARED.
# WINDOWS_EXPORT_ALL_SYMBOLS (lbr-stack/fri issue #13) corrupts nanopb decode
# callbacks on MSVC, causing getIpoJointPosition() to return all zeros.
# A static library embedded directly into _pyfri.pyd avoids this entirely.
FetchContent_Declare(
    FRI
    GIT_REPOSITORY https://github.com/lbr-stack/fri
    GIT_TAG fri-${FRI_CLIENT_VERSION_MAJOR}.${FRI_CLIENT_VERSION_MINOR}
    PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/patch_fri_static.cmake
)

FetchContent_MakeAvailable(FRI)

add_subdirectory(pybind)

pybind11_add_module(_pyfri ${CMAKE_CURRENT_SOURCE_DIR}/pyfri/src/wrapper.cpp)

target_include_directories(
    _pyfri
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/pyfri/src
)

target_link_libraries(_pyfri PRIVATE FRIClient)
