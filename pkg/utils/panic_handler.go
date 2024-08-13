/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package utils

import (
	"fmt"

	"github.com/rs/zerolog/log"
)

func HandlePanic(r any, errMessage string) {
	err := fmt.Errorf("panic: %v", r)
	log.Err(err).Msg(errMessage)
}
