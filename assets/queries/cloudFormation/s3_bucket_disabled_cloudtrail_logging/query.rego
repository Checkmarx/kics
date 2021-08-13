package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	resource2 := input.document[i].Resources[name2]
	resource2.Type == "AWS::S3::BucketPolicy"
	resource2.Properties.Bucket.Ref == name
	resource2.Properties.PolicyDocument.Statement[0].Principal.Service == "cloudtrail.amazonaws.com"

	not common_lib.valid_key(resource.Properties, "LoggingConfiguration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("S3 bucket '%s' should have logging enabled", [name]),
		"keyActualValue": sprintf("S3 bucket '%s' doesn't have logging enabled", [name]),
	}
}
