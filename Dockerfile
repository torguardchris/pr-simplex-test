FROM debian:bullseye AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y git

RUN git clone https://github.com/simplex-chat/simplexmq.git /build

RUN apt install -y haskell-platform haskell-stack
RUN apt install -y build-essential libnuma1 libnuma-dev libtinfo-dev libtinfo5 libtinfo6 libc6-dev llvm*
RUN apt install -y clang ninja-build
RUN cd /build; stack build
RUN mv /build/apps/ntf-server /build/apps/ntf-server-$(uname -m)
RUN mv /build/apps/smp-server /build/apps/smp-server-$(uname -m)

FROM scratch AS export
COPY --from=build /build/apps .