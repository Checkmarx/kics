package kics

import (
	"encoding/json"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
)

func TestKics_prepareDocument(t *testing.T) {
	type args struct {
		bodyType string
		kind     model.FileKind
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "prepare document simple test",
			args: args{
				bodyType: `
				{
					"document": [
					  {
						"resource": {
						  "aws_cloudwatch_log_metric_filter": {
							"cis_changes_nacl": {
							  "name": "CIS-4.11-Changes-NACL",
							  "pattern": "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }",
							  "log_group_name": "${aws_cloudwatch_log_group.CIS_CloudWatch_LogsGroup.name}",
							  "metric_transformation": {
								"name": "CIS-4.11-Changes-NACL",
								"namespace": "CIS_Metric_Alarm_Namespace",
								"value": "1",
								"_kics_lines": {
								  "_kics__default": {
									"_kics_line": 6
								  },
								  "_kics_name": {
									"_kics_line": 7
								  },
								  "_kics_namespace": {
									"_kics_line": 8
								  },
								  "_kics_value": {
									"_kics_line": 9
								  }
								}
							  },
							  "_kics_lines": {
								"_kics__default": {
								  "_kics_line": 1
								},
								"_kics_log_group_name": {
								  "_kics_line": 4
								},
								"_kics_metric_transformation": {
								  "_kics_line": 6
								},
								"_kics_name": {
								  "_kics_line": 2
								},
								"_kics_pattern": {
								  "_kics_line": 3
								}
							  }
							}
						  }
						},
						"_kics_lines": {
						  "_kics__default": {
							"_kics_line": 0
						  },
						  "_kics_resource": {
							"_kics_line": 1
						  }
						}
					  }
					]
				  }
				`,
				kind: model.KindTerraform,
			},
			want: `
			{
				"document": [
				  {
					"resource": {
					  "aws_cloudwatch_log_metric_filter": {
						"cis_changes_nacl": {
						  "log_group_name": "${aws_cloudwatch_log_group.CIS_CloudWatch_LogsGroup.name}",
						  "metric_transformation": {
							"name": "CIS-4.11-Changes-NACL",
							"namespace": "CIS_Metric_Alarm_Namespace",
							"value": "1"
						  },
						  "name": "CIS-4.11-Changes-NACL",
						  "pattern": "{\"_kics_filter_expr\":{\"_op\":\"||\",\"_left\":{\"_op\":\"||\",\"_left\":{\"_op\":\"||\",\"_left\":{\"_op\":\"||\",\"_left\":{\"_op\":\"||\",\"_left\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"CreateNetworkAcl\"},\"_right\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"CreateNetworkAclEntry\"}},\"_right\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"DeleteNetworkAcl\"}},\"_right\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"DeleteNetworkAclEntry\"}},\"_right\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"ReplaceNetworkAclEntry\"}},\"_right\":{\"_selector\":\"$.eventName\",\"_op\":\"=\",\"_value\":\"ReplaceNetworkAclAssociation\"}}}"
						}
					  }
					}
				  }
				]
			  }

			`,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			interf := make(map[string]interface{})
			err := json.Unmarshal([]byte(tt.args.bodyType), &interf)
			require.NoError(t, err)

			got := PrepareScanDocument(interf, tt.args.kind)
			compareJSONLine(t, got, tt.want)
		})
	}
}

func TestKics_resolveCRLFFile(t *testing.T) {
	tests := []struct {
		name     string
		body     string
		expected string
	}{
		{
			name:     "CRLF File should not contain '\\r'",
			body:     "Resources:\r\nDemoSecurityGroup:\r\nType: 'AWS::EC2::SecurityGroup'\r\nProperties:\r\nVpcId: !Ref myVPC\r\nGroupDescription: Ports open to the world\r\nSecurityGroupIngress:\r\n- Description: Allowing port 22 for everyone\r\nIpProtocol: tcp\r\nFromPort: 22\r\nToPort: 22\r\nCidrIp: \"0.0.0.0/0\"\r\n# kics-scan ignore-block\r\n- Description: Allowing port 80 for everyone\r\nIpProtocol: tcp\r\nFromPort: 80\r\nToPort: 80\r\nCidrIp: \"0.0.0.0/0\"",
			expected: "Resources:\nDemoSecurityGroup:\nType: 'AWS::EC2::SecurityGroup'\nProperties:\nVpcId: !Ref myVPC\nGroupDescription: Ports open to the world\nSecurityGroupIngress:\n- Description: Allowing port 22 for everyone\nIpProtocol: tcp\nFromPort: 22\nToPort: 22\nCidrIp: \"0.0.0.0/0\"\n# kics-scan ignore-block\n- Description: Allowing port 80 for everyone\nIpProtocol: tcp\nFromPort: 80\nToPort: 80\nCidrIp: \"0.0.0.0/0\"",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			resolved := resolveCRLFFile([]byte(tt.body))
			require.Equal(t, tt.expected, string(resolved), "Resolved content does not match expected output")
			require.NotContains(t, string(resolved), "\r", "Resolved content contains '\\r'")
		})
	}
}

func compareJSONLine(t *testing.T, test1 interface{}, test2 string) {
	stringefiedJSON, err := json.Marshal(&test1)
	require.NoError(t, err)
	require.JSONEq(t, test2, string(stringefiedJSON))
}
