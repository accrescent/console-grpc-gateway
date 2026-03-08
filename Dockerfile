# SPDX-FileCopyrightText: © 2026 Logan Magee
#
# SPDX-License-Identifier: AGPL-3.0-only

FROM golang:1.26.1-alpine@sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039 AS builder

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
