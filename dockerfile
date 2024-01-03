# dev image
FROM ubuntu:22.04 as dev

# install Node.js
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \ 
    tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install nodejs -y && \
    apt-get clean

# install Yarn
RUN corepack enable

# install Go
WORKDIR /home/downloads
RUN curl -LO https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# copy source files
WORKDIR /home/hello-world-grd
COPY . .

# build Go bin
WORKDIR /home/hello-world-grd/server
RUN go build -o bin/

# install React dependencies and create production build
WORKDIR /home/hello-world-grd/client
RUN yarn install && \
    yarn build

# production image
FROM scratch as prod
COPY --from=dev /home/hello-world-grd/server/bin/server server/bin/
COPY --from=dev /home/hello-world-grd/client/build/ client/build/

EXPOSE 8000
