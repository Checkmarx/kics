package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	bucket := resource.Properties.BucketName
	not bucketName(bucket)
    not bucketName(name)
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.BucketName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' should be the same as 'AWS::S3::BucketPolicy' Bucket Ref", [name, name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' are not the same as 'AWS::S3::BucketPolicy' Bucket Ref", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	object.get(resource.Properties, "BucketName", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BucketName' should be defined in 'AWS::S3::Bucket'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BucketName' is not defined in 'AWS::S3::Bucket'", [name]),
	}
}

bucketName(bucketName) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucket := resource.Properties.Bucket
    not contains(bucket, "!Ref")
	bucket == bucketName
}

bucketName(bucketName) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucket := resource.Properties.Bucket
    contains(bucket, "!Ref")
    bucketN := replace(bucket, "!Ref ", "")
	bucket == bucketName
}

bucketName(bucketName) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucket := resource.Properties.Bucket.Ref
	bucket == bucketName
}
