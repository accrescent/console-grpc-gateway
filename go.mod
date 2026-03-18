// SPDX-FileCopyrightText: © 2026 Logan Magee
//
// SPDX-License-Identifier: AGPL-3.0-only

module golang.accrescent.app/api-grpc-gateway

go 1.26.0

require (
	buf.build/gen/go/accrescent/console-api/grpc-ecosystem/gateway/v2 v2.28.0-20260310011136-40b579234203.1
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.28.0
	google.golang.org/genproto/googleapis/rpc v0.0.0-20260311181403-84a4fc48630c
	google.golang.org/grpc v1.79.3
)

require (
	buf.build/gen/go/accrescent/console-api/grpc/go v1.6.1-20260310011136-40b579234203.1 // indirect
	buf.build/gen/go/accrescent/console-api/protocolbuffers/go v1.36.11-20260310011136-40b579234203.1 // indirect
	buf.build/gen/go/bufbuild/protovalidate/protocolbuffers/go v1.36.11-20260209202127-80ab13bee0bf.1 // indirect
	buf.build/gen/go/grpc-ecosystem/grpc-gateway/protocolbuffers/go v1.36.11-20260102203250-6467306b4f62.1 // indirect
	cloud.google.com/go/longrunning v0.8.0 // indirect
	golang.org/x/net v0.51.0 // indirect
	golang.org/x/sys v0.41.0 // indirect
	golang.org/x/text v0.34.0 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20260226221140-a57be14db171 // indirect
	google.golang.org/protobuf v1.36.11 // indirect
)
