# 라이브러리 정적 링크 custom triplet
# target : x64-linux

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)

# 이 부분이 해당 역할의 핵심
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)