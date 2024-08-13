/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package console

import (
	"context"

	"github.com/Checkmarx/kics/pkg/scan"
	"github.com/rs/zerolog/log"
)

func ExecuteScan(scanParams *scan.Parameters) error {
	log.Debug().Msg("console.scan()")
	ctx := context.Background()

	console := newConsole()

	console.preScan(scanParams)

	client, err := scan.NewClient(scanParams, console.ProBarBuilder, console.Printer)

	if err != nil {
		log.Err(err)
		return err
	}

	err = client.PerformScan(ctx)

	if err != nil {
		log.Err(err)
		return err
	}

	return nil
}
