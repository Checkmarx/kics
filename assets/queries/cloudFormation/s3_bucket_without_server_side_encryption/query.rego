package Cx

# return every bucket as result if there are no policies defined
CxPolicy [ result ] {
	document := input.document[i]
    resources := document.Resources
    some resource
    resources[resource].Type == "AWS::S3::Bucket"

	bucketName := resource

    not bucketHasServerSideEncryptionRules(resources[bucketName])

    result := {
        "documentId": 		document.id,
        "searchKey": 	    sprintf("Resources.%s", [bucketName]),
        "issueType":		"MissingAttribute",
        "keyExpectedValue": sprintf("Resources.%s bucket should server-side encryption enabled", [bucketName]),
        "keyActualValue": 	sprintf("Resources.%s bucket doesn't have any server-side encryption configuration", [bucketName])
    }
}

bucketHasServerSideEncryptionRules(bucket){
	count(bucket.Properties.BucketEncryption.ServerSideEncryptionConfiguration) > 0
}