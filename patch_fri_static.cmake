# Patch script: changes FRIClient from SHARED to STATIC in the FRI SDK.
# Run from the fri source directory (ExternalProject/FetchContent PATCH_COMMAND cwd).
#
# Reason: WINDOWS_EXPORT_ALL_SYMBOLS causes nanopb decode callbacks to
# malfunction on MSVC (lbr-stack/fri issue #13). Linking statically avoids
# DLL symbol export entirely.
cmake_minimum_required(VERSION 3.5)

file(READ "CMakeLists.txt" _content)
string(REPLACE
    "add_library(FRIClient SHARED"
    "add_library(FRIClient STATIC"
    _content "${_content}"
)
file(WRITE "CMakeLists.txt" "${_content}")
message(STATUS "[patch_fri_static] Patched FRIClient: SHARED -> STATIC")
