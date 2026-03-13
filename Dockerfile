# SPDX-FileCopyrightText: © 2026 Logan Magee
#
# SPDX-License-Identifier: AGPL-3.0-only

FROM golang:1.26.1-alpine@sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039 AS builder

WORKDIR /build
COPY go.mod go.sum .
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 go build

FROM cgr.dev/chainguard/static:latest@sha256:2fdfacc8d61164aa9e20909dceec7cc28b9feb66580e8e1a65b9f2443c53b61b

WORKDIR /app
COPY --from=builder /build/api-grpc-gateway .

USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/app/api-grpc-gateway"]
