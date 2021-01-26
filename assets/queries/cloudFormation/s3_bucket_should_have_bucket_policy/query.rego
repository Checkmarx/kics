package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucket := resource.Properties.Bucket
	not bucketName(bucket)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Bucket", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Bucket' is the same as BucketName", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Bucket' is not the same as BucketName", [name]),
	}
}

bucketName(bucketName) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	resource.Properties.BucketName == bucketName
} else = false {
	true
}
