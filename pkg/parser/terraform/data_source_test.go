package terraform

import (
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/converter"
	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty"
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
		{
			name: "should load data source as json without errors 3",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "support_site_bucket_policy_document",
			},
			want: `{"Statement":[{"Actions":["s3:GetObject"],"Condition":{"Bool":{"aws:SecureTransport":["true"]}},"Effect":"Allow","Principals":{"AWS":["support_site_origin_access_identity.iam_arn"]},"Resources":["arn:aws:s3:::local.support_site_bucket_name/*"],"Sid":"AllowCloudFrontAccess"}],"Version":"2012-10-17"}
`,
		},
		{
			name: "should load data source with count as json without errors",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "ssmlogs-s3-bucket",
			},
			want: `{"Statement":[{"Actions":["s3:*"],"Condition":{"Bool":{"aws:SecureTransport":["false"]}},"Effect":"Deny","Principals":{"*":["*"]},"Resources":["arn:aws:s3:::aws_s3_bucket.ssmlogs-s3-bucket.0.bucket","arn:aws:s3:::aws_s3_bucket.ssmlogs-s3-bucket.0.bucket/*"],"Sid":"EnforceSSLOnlyRequests"}]}
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
			got := getDataSourcePolicyJSON(t, data, tt.args.resourceName)
			require.Equal(t, tt.want, got)
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}

func getDataSourcePolicyJSON(t *testing.T, data cty.Value, resourceName string) string {
	t.Helper()

	policies := data.GetAttr("aws_iam_policy_document").AsValueMap()
	policy, ok := policies[resourceName]
	require.True(t, ok)

	if policy.Type().IsTupleType() {
		policy = policy.Index(cty.NumberIntVal(0))
	}

	return policy.GetAttr("json").AsString()
}
