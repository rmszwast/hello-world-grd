## About
A simple "Hello, World!" web app to get some practice with the Go + React stack and Docker.

## Prerequisites
Docker version 24.0.7

## Build Instructions
`cd` to the repository and run `docker build -t <tag> .`, where `<tag>` is the desired image name.

## Run Instructions
Run `docker run -itp 8000:8000 --rm <tag>`. \
Navigate to `http://localhost:8000`.