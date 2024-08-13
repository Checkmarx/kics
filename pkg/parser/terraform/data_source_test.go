/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package terraform

import (
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty/gocty"
)

func Test_getDataSourcePolicy(t *testing.T) {
	type args struct {
		currentPath  string
		resourceName string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "should load data source as json without errors 1",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "test_destination_policy",
			},
			want: `{"Statement":[{"Actions":["logs:*"],"Effect":"Allow","Principals":{"AWS":["data.aws_caller_identity.current.id"]}}]}
`,
		},
		{
			name: "should load data source as json without errors 2",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "test_example",
			},
			want: `{"Id":"lala","Statement":[{"Actions":["s3:ListAllMyBuckets","s3:GetBucketLocation"],"Resources":["arn:aws:s3:::*"],"Sid":"1"},{"Actions":["s3:ListBucket"],"Condition":{"StringLike":{"s3:prefix":["","home/","home/&{aws:username}/"]}},"Resources":["arn:aws:s3:::test"]},{"Actions":["s3:*"],"Resources":["arn:aws:s3:::test/home/&{aws:username}","arn:aws:s3:::test/home/&{aws:username}/*"]}]}
`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			getDataSourcePolicy(tt.args.currentPath)
			data, ok := inputVariableMap["data"]
			if !ok {
				t.FailNow()
			}
			var awsPolicyMap map[string]map[string]map[string]string
			err := gocty.FromCtyValue(data, &awsPolicyMap)
			if err != nil {
				t.Errorf("getDataSourcePolicy() error = %v", err)
			}
			got, ok := awsPolicyMap["aws_iam_policy_document"][tt.args.resourceName]["json"]
			if !ok {
				t.FailNow()
			}
			require.Equal(t, tt.want, got)
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}
