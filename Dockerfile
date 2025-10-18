# =========================================================================
# 1. Builder Stage
# ubuntu:22.04 대신, 우리가 만든 vcpkg 베이스 이미지를 불러옵니다.
# =========================================================================
FROM my-vcpkg-base:latest AS builder

WORKDIR /app

# vcpkg 라이브러리 설치 과정이 모두 생략되므로,
# 바로 전체 소스 코드를 복사합니다.
COPY . .

# Vcpkg의 위치를 CMake에 알려주는 환경변수는 여전히 유용합니다.
ENV VCPKG_ROOT=/opt/vcpkg

# CMake를 사용하여 프로젝트 빌드
# vcpkg 설치 과정이 이미 끝났으므로, 이 단계는 순수하게 
# 내 소스 코드만 컴파일하여 매우 빠르게 끝납니다.
RUN cmake --preset release-linux-clang .
RUN cmake --build --preset release-build-clang-linux

RUN ls -laR /app

# =========================================================================
# 2. Final Stage: 빌드된 실행 파일을 실행하기 위한 최소 환경
# =========================================================================
FROM ubuntu:22.04 AS final

RUN apt-get update && apt install libatomic1

WORKDIR /app

COPY --from=builder /app/build/clang-release .
RUN chmod +x ./logic-server

CMD ["./logic-server"]