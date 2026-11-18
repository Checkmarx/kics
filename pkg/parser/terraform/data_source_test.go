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
		// instance selects a count index (int) or a for_each key (string); nil for a plain data source
		instance any
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
			name: "should load data source with count as indexed instances",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "counted_deny_insecure_transport",
				instance:     0,
			},
			want: `{"Statement":[{"Actions":["s3:*"],"Condition":{"Bool":{"aws:SecureTransport":["false"]}},"Effect":"Deny","Principals":{"*":["*"]},"Resources":["arn:aws:s3:::counted/*"],"Sid":"DenyInsecureTransport"}]}
`,
		},
		{
			name: "should load data source with for_each as keyed instances",
			args: args{
				currentPath:  filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_data_source"),
				resourceName: "for_each_deny_insecure_transport",
				instance:     "assets",
			},
			want: `{"Statement":[{"Actions":["s3:*"],"Condition":{"Bool":{"aws:SecureTransport":["false"]}},"Effect":"Deny","Principals":{"*":["*"]},"Resources":["arn:aws:s3:::for-each/*"],"Sid":"DenyInsecureTransport"}]}
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
			documents := data.GetAttr("aws_iam_policy_document")
			require.True(t, documents.Type().HasAttribute(tt.args.resourceName), "data source %s not loaded", tt.args.resourceName)
			document := documents.GetAttr(tt.args.resourceName)
			switch instance := tt.args.instance.(type) {
			case int:
				document = document.Index(cty.NumberIntVal(int64(instance)))
			case string:
				document = document.GetAttr(instance)
			}
			require.Equal(t, tt.want, document.GetAttr("json").AsString())
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}
