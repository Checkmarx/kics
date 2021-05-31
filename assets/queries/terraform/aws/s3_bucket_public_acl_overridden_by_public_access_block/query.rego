package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	publicBlockACL := input.document[j].resource.aws_s3_bucket_public_access_block[blockName]

	split(publicBlockACL.bucket, ".")[1] == name

	publicBlockACL.block_public_acls == true
	publicBlockACL.block_public_policy == true
	publicBlockACL.ignore_public_acls == true
	publicBlockACL.restrict_public_buckets == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL is not overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true
