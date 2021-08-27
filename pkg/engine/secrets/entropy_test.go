package secrets

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

var (
	calculateEntropyTestCases = []struct {
		name        string
		input       string
		charSetType string
		high        bool
	}{
		{
			name:        "empty string - hex",
			input:       "",
			charSetType: "hex",
			high:        false,
		},
		{
			name:        "empty string - base64",
			input:       "",
			charSetType: "base64",
			high:        false,
		},
		{
			name:        "low entropy - 1 char - hex",
			input:       "a",
			charSetType: "hex",
			high:        false,
		},
		{
			name:        "low entropy - 1 char - base64",
			input:       "a",
			charSetType: "base64",
			high:        false,
		},
		{
			name:        "low entropy - hex",
			input:       "123xzb22",
			charSetType: "hex",
			high:        false,
		},
		{
			name:        "low entropy - base64",
			input:       "abc123s/=",
			charSetType: "base64",
			high:        false,
		},
		{
			name:        "high entropy - hex",
			input:       "000068067656e7420666f722074686520417a75",
			charSetType: "hex",
			high:        true,
		},
		{
			name:        "high entropy - base64",
			input:       "MIIB/TCCAWYCCQDK5QPVVgU3jzANBgkqhkiG9w0BAQUFADBDMQswCQYDVQQGEwJV",
			charSetType: "base64",
			high:        true,
		},
		{
			name:        "high entropy - base64 - large",
			input:       "MIIB/TCCAWYCCQDK5QPVVgU3jzANBgkqhkiG9w0BAQUFADBDMQswCQYDVQQGEwJVnb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS", //nolint:lll
			charSetType: "base64",
			high:        true,
		},
		{
			name: "high entropy - base64 - private key",
			input: `-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----`,
			charSetType: "base64",
			high:        true,
		},
	}

	testGetHighEntropyTokensTestCases = []struct {
		name     string
		input    string
		fileName string
		line     int
		high     bool
	}{
		{
			name:  "empty string",
			input: "",
			high:  false,
		},
		{
			name:  "low entropy - 1 char",
			input: "a",
			high:  false,
		},
		{
			name:  "low entropy - 20 chars",
			input: "111111111111111111111",
			high:  false,
		},
		{
			name:  "medium entropy - 20 chars",
			input: "12345678901234567890",
			high:  false,
		},
		{
			name:  "low entropy - 21 chars",
			input: "111111111111111111111",
			high:  false,
		},
		{
			name:  "low entropy - 21 chars",
			input: "111111111112222222222",
			high:  false,
		},
		{
			name:  "low entropy - 21 chars",
			input: "1111113333332222222222",
			high:  false,
		},
		{
			name:  "medium entropy - 23 chars",
			input: "12345678901234567890123",
			high:  true,
		},
		{
			name:  "high entropy - 49 chars",
			input: "12A34B5678aSaskT1cai12e12=1241/25901234567O890123",
			high:  true,
		},
		{
			name:  "Dockerfile header",
			input: "FROM golang:1.17.0-buster as build_env",
			high:  false,
		},
		{
			name: "RSA Private Key",
			input: `-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----`,
			high: true,
		},
		{
			name: "Terraform With AWS Access Key",
			input: `
resource "aws_instance" "web" {
	ami           = data.aws_ami.ubuntu.id
	instance_type = "t3.micro"

	user_data = <<EOT
	cat <<EOF > ~/.bashrc
	export AWS_ACCESS_KEY_ID="AKIVSWLNK7XVIA4YCIU9"
	export AWS_SECRET_ACCESS_KEY="xEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3A"
	EOF
	EOT

	tags = {
		Name = "Dummy Test"
	}
}`,
			high: true,
		},
		{
			name: "Terraform With RSA private Key",
			input: `
resource "aws_transfer_ssh_key" "example" {
	server_id = aws_transfer_server.example.id
	user_name = aws_transfer_user.example.user_name
	body      = <<EOT
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----
EOT
}`,
			high: true,
		},
	}
)

func TestCalculateEntropy(t *testing.T) {
	for _, tc := range calculateEntropyTestCases {
		t.Run(tc.name, func(t *testing.T) {
			var charSet string
			var threshold float64
			if tc.charSetType == HexType {
				charSet = HexChars
				threshold = HexCharsEntropyThreashold
			} else {
				charSet = Base64Chars
				threshold = Base64EntropyThreashold
			}
			entropy := CalculateEntropy(tc.input, charSet)
			if tc.high {
				require.Greater(t, entropy, threshold,
					fmt.Sprintf("test[%s] Entropy should be greater than %f, actual: %v, input: %v", tc.name, threshold, entropy, tc.input))
			} else {
				require.Less(t, entropy, threshold,
					fmt.Sprintf("test[%s] Entropy should be less than %f, actual: %v, input: %v", tc.name, threshold, entropy, tc.input))
			}
		})
	}
}

func TestGetHighEntropyTokens(t *testing.T) {
	for _, tc := range testGetHighEntropyTokensTestCases {
		t.Run(tc.name, func(t *testing.T) {
			matches := GetHighEntropyTokens(tc.input)
			if tc.high {
				require.NotEmpty(t, matches, fmt.Sprintf("test[%s] tokens should not be empty\ninput: %v", tc.name, tc.input))
			} else {
				require.Empty(t, matches, fmt.Sprintf("test[%s] tokens should be empty\ninput: %v", tc.name, tc.input))
			}
		})
	}
}
