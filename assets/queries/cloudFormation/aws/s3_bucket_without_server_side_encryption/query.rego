package Cx

import data.generic.cloudformation as cf_lib

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
		"resourceType": resources[resource].Type,
		"resourceName": cf_lib.get_resource_name(resources[resource], resource),
		"searchKey": sprintf("Resources.%s.Properties", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration should be defined and not empty", [bucketName]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration is undefined or empty", [bucketName]),
	}
}

bucketHasServerSideEncryptionRules(bucket) {
	count(bucket.Properties.BucketEncryption.ServerSideEncryptionConfiguration) > 0
}
