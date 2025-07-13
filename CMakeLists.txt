cmake_minimum_required(VERSION 3.28) # minimum version of cmake
project(logic-server) # project name

set(CMAKE_CXX_STANDARD 20) # c++20 standard

if(NOT DEFINED ENV{VCPKG_ROOT})
    message(FATAL_ERROR "Error: VCPKG_ROOT environment variable is not set. Please set it to your vcpkg installation directory.")
endif()

set(CMAKE_PREFIX_PATH "$ENV{VCPKG_ROOT}/installed/x64-linux")

set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "" FORCE)
set(VCPKG_MANIFEST_MODE ON)


find_package(Boost REQUIRED COMPONENTS asio)
find_package(Boost REQUIRED COMPONENTS uuid)
find_package(spdlog CONFIG REQUIRED)
find_package(protobuf CONFIG REQUIRED)

add_executable(logic-server 
                src/main.cpp 
                src/GroupManager.cpp 
                src/LockstepGroup.cpp 
                src/NetworkData.pb.cc 
                src/Server.cpp
                src/Session.cpp
)

target_include_directories(logic-server PRIVATE 
                            ${CMAKE_CURRENT_SOURCE_DIR}/includes
)

target_link_libraries(logic-server PRIVATE 
                    spdlog::spdlog 
                    Boost::asio 
                    Boost::uuid 
                    protobuf::libprotobuf
)

