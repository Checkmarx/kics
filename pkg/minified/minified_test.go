package minified

import (
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

func Test_IsMinified(t *testing.T) {
	giantMinifiedJson, _ := os.ReadFile("../../test/fixtures/test_minified/giantminified.json")
	tests := []struct {
		name     string
		nameFile string
		args     []byte
		want     bool
	}{
		{
			name:     "Mini minified file json",
			nameFile: "test.json",
			want:     true,
			args:     []byte("{\"swagger\":\"2.0\",\"info\":{\"version\":\"v1\",\"title\":\"CCBCC.LAUNCHPAD.WebApi\"},\"host\":\"apiapp-dev-lpd.azurewebsites.net\",\"schemes\":[\"https\"],\"paths\":{\"/api/BlobFileDownload\":{\"get\":{\"tags\":[\"BlobFileDownload\"],\"operationId\":\"BlobFileDownload_GetBlobFileDownload\",\"consumes\":[],\"produces\":[\"application/json\",\"text/json\",\"application/xml\",\"text/xml\"],\"responses\":{\"200\":{\"description\":\"OK\",\"schema\":{\"type\":\"object\"}}}}},\"/api/BlobFileDownload/{id}\":{\"get\":{\"tags\":[\"BlobFileDownload\"],\"operationId\":\"BlobFileDownload_Get\",\"consumes\":[],\"produces\":[\"application/json\",\"text/json\",\"application/xml\",\"text/xml\"],\"parameters\":[{\"name\":\"id\",\"in\":\"path\",\"required\":true,\"type\":\"integer\",\"format\":\"int32\"}],\"responses\":{\"200\":{\"description\":\"OK\",\"schema\":{\"type\":\"object\"}}}}}},\"definitions\":{}}"),
		},
		{
			name:     "Huge minified file json",
			nameFile: "test.json",
			want:     true,
			args:     giantMinifiedJson,
		},
		{
			name:     "File not json not yaml",
			nameFile: "test.tf",
			want:     false,
			args:     []byte(""),
		},
		{
			name:     "Mini minified file yaml",
			nameFile: "test.yml",
			want:     true,
			args:     []byte("[{name: my_elb_application, community.aws.elb_application_lb: {name: myelb, security_groups: [sg-12345678, my-sec-group], subnets: [subnet-012345678, subnet-abcdef000], listeners: [{Protocol: HTTP, Port: 80, SslPolicy: ELBSecurityPolicy-2015-05, Certificates: [{CertificateArn: 'arn:aws:iam::12345678987:server-certificate/test.domain.com'}], DefaultActions: [{Type: forward, TargetGroupName: targetname}]}], state: present}}, {name: my_elb_application2, community.aws.elb_application_lb: {name: myelb2, security_groups: [sg-12345678, my-sec-group], subnets: [subnet-012345678, subnet-abcdef000], listeners: {Port: 80, SslPolicy: ELBSecurityPolicy-2015-05, Certificates: [{CertificateArn: 'arn:aws:iam::12345678987:server-certificate/test.domain.com'}], DefaultActions: [{Type: forward, TargetGroupName: targetname}]}, state: present}}]"),
		},
		{
			name:     "Not minified file yaml",
			nameFile: "test.yml",
			want:     false,
			args:     []byte("- name: my_elb_application\n  community.aws.elb_application_lb:\n    name: myelb\n    security_groups:\n      - sg-12345678\n      - my-sec-group\n    subnets:\n      - subnet-012345678\n      - subnet-abcdef000\n    listeners:\n      - Protocol: HTTP\n        Port: 80\n        SslPolicy: ELBSecurityPolicy-2015-05\n        Certificates:\n          - CertificateArn: arn:aws:iam::12345678987:server-certificate/test.domain.com\n        DefaultActions:\n          - Type: forward\n            TargetGroupName: targetname\n    state: present\n- name: my_elb_application2\n  community.aws.elb_application_lb:\n    name: myelb2\n    security_groups:\n      - sg-12345678\n      - my-sec-group\n    subnets:\n      - subnet-012345678\n      - subnet-abcdef000\n    listeners:\n      Port: 80\n      SslPolicy: ELBSecurityPolicy-2015-05\n      Certificates:\n        - CertificateArn: arn:aws:iam::12345678987:server-certificate/test.domain.com\n      DefaultActions:\n        - Type: forward\n          TargetGroupName: targetname\n    state: present\n"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := IsMinified(tt.nameFile, tt.args)
			if tt.want {
				assert.True(t, result, tt.name)
			} else {
				assert.False(t, result, tt.name)
			}
		})
	}
}
