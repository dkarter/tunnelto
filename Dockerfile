# --------- BUILDER -----------------

FROM rust:alpine as builder

WORKDIR "/app"

COPY . .

# set up build tools
RUN apk add build-base pkgconfig openssl-dev

# build the release
RUN cargo build --release

# --------- RUNNER ------------------

FROM alpine:latest

WORKDIR "/app"

RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/target/release/tunnelto_server ./tunnelto_server

USER nobody

# client svc
EXPOSE 8080
# ctrl svc
EXPOSE 5000
# net svc
EXPOSE 10002

ENTRYPOINT ["/app/tunnelto_server"]
