# linux migrated logic server
## Required
- OS : One of Linux, MacOS, Windows
- Tools
  - Docker
  - Docker Compose
 
## Run Code On Docker Container
- clone repository
```sh
git clone https://github.com/thejae-u/linux-migrated-logic-server.git
```
- Move to directory
```sh
cd ~/linux-migrated-logic-server
```
- First Build vcpkg image
```sh
docker build -f vcpkg.base.dockerfile -t my-vcpkg-base:latest .
```

- build project
```sh
docker compose up -d --build
```
