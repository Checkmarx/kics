package Cx

# return every bucket as result if there are no policies defined
CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucketName := resource

	not bucketHasServerSideEncryptionRules(resources[bucketName])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration is defined and not empty", [bucketName]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration is undefined or empty", [bucketName]),
	}
}

bucketHasServerSideEncryptionRules(bucket) {
	count(bucket.Properties.BucketEncryption.ServerSideEncryptionConfiguration) > 0
}
