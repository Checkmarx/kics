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
}
