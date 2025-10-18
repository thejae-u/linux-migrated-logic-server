cmake_minimum_required(VERSION 3.28) # minimum version of cmake
project(logic-server) # project name

set(CMAKE_CXX_STANDARD 20) # c++20 standard

if(NOT DEFINED ENV{VCPKG_ROOT})
    message(FATAL_ERROR "Error: VCPKG_ROOT environment variable is not set. Please set it to your vcpkg installation directory.")
endif()

set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "" FORCE)
set(VCPKG_MANIFEST_MODE ON)

# 이 triplet은 기존 x64-linux를 기반으로 합니다.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)

# ‼️ 가장 중요한 부분: 모든 라이브러리를 정적으로 링크하도록 설정합니다.
set(VCPKG_LIBRARY_LINKAGE static)

# 타겟 시스템을 Linux로 지정합니다.
set(VCPKG_CMAKE_SYSTEM_NAME Linux)

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

