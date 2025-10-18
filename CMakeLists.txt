cmake_minimum_required(VERSION 3.28) # minimum version of cmake
project(logic-server) # project name

set(CMAKE_CXX_STANDARD 20) # c++20 standard

if(NOT DEFINED ENV{VCPKG_ROOT})
    message(FATAL_ERROR "Error: VCPKG_ROOT environment variable is not set. Please set it to your vcpkg installation directory.")
endif()

set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "" FORCE)
set(VCPKG_MANIFEST_MODE ON)

find_package(Boost REQUIRED COMPONENTS asio)
find_package(Boost REQUIRED COMPONENTS uuid)
find_package(spdlog CONFIG REQUIRED)
find_package(protobuf CONFIG REQUIRED)

# Protobuf compile
include(FindProtobuf)
set(PROTO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/protos/NetworkData.proto)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILES})

add_executable(logic-server 
                src/main.cpp 
                src/GroupManager.cpp 
                src/LockstepGroup.cpp 
                src/Server.cpp
                src/Session.cpp
                ${PROTO_SRCS}
)

target_include_directories(logic-server PRIVATE 
                            ${CMAKE_CURRENT_SOURCE_DIR}/includes
                            ${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(logic-server PRIVATE 
                    spdlog::spdlog 
                    Boost::asio 
                    Boost::uuid 
                    protobuf::libprotobuf
)

