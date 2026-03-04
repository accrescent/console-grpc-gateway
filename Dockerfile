# SPDX-FileCopyrightText: © 2026 Logan Magee
#
# SPDX-License-Identifier: AGPL-3.0-only

FROM golang:1.26.0-alpine@sha256:d4c4845f5d60c6a974c6000ce58ae079328d03ab7f721a0734277e69905473e5 AS builder

WORKDIR /build
COPY go.mod go.sum .
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 go build

FROM cgr.dev/chainguard/static:latest@sha256:d6a97eb401cbc7c6d48be76ad81d7899b94303580859d396b52b67bc84ea7345

WORKDIR /app
COPY --from=builder /build/api-grpc-gateway .

USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/app/api-grpc-gateway"]
