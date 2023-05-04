cmake_minimum_required(VERSION 3.22)

project(LuaJIT-MinHook
    VERSION 1.1.2
    LANGUAGES CXX C
)

set(CMAKE_CXX_STANDARD 20)

include(CTest)
include(FetchContent)

FetchContent_Declare(MinHook
    GIT_REPOSITORY https://github.com/TsudaKageyu/minhook.git
    GIT_TAG 4a455528f61b5a375b1f9d44e7d296d47f18bb18)
FetchContent_MakeAvailable(MinHook)


add_library(luajit_minhook MODULE
    minhook.cpp
    std_string.cpp
)

target_link_libraries(luajit_minhook PRIVATE minhook)

install(TARGETS luajit_minhook
    COMPONENT LuaJIT-MinHook
    DESTINATION "."
)

install(FILES minhook.lua
    COMPONENT LuaJIT-MinHook
    DESTINATION "."
)

add_subdirectory(packaging)
