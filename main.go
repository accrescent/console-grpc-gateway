// SPDX-FileCopyrightText: © 2026 Logan Magee
//
// SPDX-License-Identifier: AGPL-3.0-only

package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/textproto"

	gw "buf.build/gen/go/accrescent/console-api/grpc-ecosystem/gateway/v2/accrescent/console/v1alpha1/consolev1alpha1gateway"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	_ "google.golang.org/genproto/googleapis/rpc/errdetails"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/grpclog"
)

const appVersion = "0.1.1"

func main() {
	cfg := &config{}
	flag.StringVar(
		&cfg.backendEndpoint,
		"grpc-server-endpoint",
		"localhost:50051",
		"gRPC server endpoint",
	)
	flag.UintVar(
		&cfg.listenPort,
		"listen-port",
		8080,
		"port to listen on",
	)
	flag.Parse()

	if err := run(cfg); err != nil {
		grpclog.Fatal(err)
	}
}

type config struct {
	backendEndpoint string
	listenPort      uint
}

func run(config *config) error {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	opts := []grpc.DialOption{grpc.WithTransportCredentials(insecure.NewCredentials())}
	conn, err := grpc.NewClient(config.backendEndpoint, opts...)
	if err != nil {
		return err
	}
	defer func() {
		if cerr := conn.Close(); err != nil {
			grpclog.Errorf("Failed to close conn to %s: %v", config.backendEndpoint, cerr)
		}
	}()

	mux := runtime.NewServeMux(runtime.WithIncomingHeaderMatcher(headerMatcher))
	if err := gw.RegisterAppDraftServiceHandler(ctx, mux, conn); err != nil {
		return err
	}
	if err := gw.RegisterAppEditServiceHandler(ctx, mux, conn); err != nil {
		return err
	}
	if err := gw.RegisterAppServiceHandler(ctx, mux, conn); err != nil {
		return err
	}
	if err := gw.RegisterOrganizationServiceHandler(ctx, mux, conn); err != nil {
		return err
	}
	if err := gw.RegisterReviewServiceHandler(ctx, mux, conn); err != nil {
		return err
	}
	if err := gw.RegisterUserServiceHandler(ctx, mux, conn); err != nil {
		return err
	}

	listenAddr := fmt.Sprintf(":%d", config.listenPort)
	log.Printf("Starting gateway version %s on %s", appVersion, listenAddr)

	return http.ListenAndServe(listenAddr, mux)
}

func headerMatcher(key string) (string, bool) {
	key = textproto.CanonicalMIMEHeaderKey(key)

	switch key {
	case "Cookie":
		return key, true
	default:
		return "", false
	}
}
