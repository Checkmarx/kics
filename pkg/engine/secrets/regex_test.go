package secrets

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestApplyAllRegexex(t *testing.T) {
	testCase := []struct {
		name  string
		input string
		match bool
		file  string
		line  int
	}{
		{
			name:  "simple test1",
			input: "test1",
			match: false,
		},
		{
			name:  "empty",
			input: "",
			match: false,
		},
		{
			name:  "Facebook Token",
			input: "EAACEdEose0cBAaisd12uqiwdasbdwi221",
			match: true,
		},
		{
			name: "OPENSSH private key",
			input: `
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----`,
			match: true,
		},
		{
			name:  "Basic Authentication in URL",
			input: "https://username:myPassword@my.domain.com",
			match: true,
		},
		{
			name:  "AWS API KEY",
			input: "AKIS21K2541012G2BKJ5",
			match: true,
		},
		{
			name:  "Normal terraform line",
			input: "resource \"google_compute_instance\" \"positive1\" {",
			match: false,
		},
		{
			name:  "Random comment",
			input: "# this is a random comment",
			match: false,
		},
		{
			name:  "Dockerfile header",
			input: "FROM golang:1.17.0-buster as build_env",
			match: false,
		},
	}

	for _, tc := range testCase {
		t.Run(tc.name, func(t *testing.T) {
			result := ApplyAllRegexRules(tc.input)
			if tc.match {
				require.NotEmpty(t, result, fmt.Sprintf("test[%s] tokens should not be empty\ninput: %v", tc.name, tc.input))
			} else {
				require.Empty(t, result, fmt.Sprintf("test[%s] tokens should be empty\ninput: %v", tc.name, tc.input))
			}
		})
	}
}
