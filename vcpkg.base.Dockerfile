FROM ubuntu:22.04

# 빌드에 필요한 기본 도구들을 설치합니다.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential ca-certificates g++ gcc clang ninja-build git curl wget zip unzip pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.sh \
    -O /tmp/cmake-install.sh && \
    chmod +x /tmp/cmake-install.sh && \
    /tmp/cmake-install.sh --skip-license --prefix=/usr/local && \
    rm /tmp/cmake-install.sh

# Vcpkg 설치
ENV VCPKG_ROOT=/opt/vcpkg
RUN git -c http.sslVerify=false clone https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT}
RUN ${VCPKG_ROOT}/bootstrap-vcpkg.sh

# =========================================================================
# 🔽 1단계에서 만든 커스텀 triplet 파일을 이미지 안으로 복사합니다.
# =========================================================================
COPY x64-linux-static.cmake ${VCPKG_ROOT}/triplets/

WORKDIR /opt/vcpkg_build

# 사용할 라이브러리 목록 파일 복사
COPY vcpkg.json .

# vcpkg install 명령으로 라이브러리만 미리 빌드하여 이미지에 저장
# CMake를 실행할 필요 없이 vcpkg로 직접 설치하면 더 명확함
RUN ${VCPKG_ROOT}/vcpkg install --triplet=x64-linux-static