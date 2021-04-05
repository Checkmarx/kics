package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl=%s", [name, resource.acl]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' is equal 'private'",
		"keyActualValue": sprintf("'acl' is equal '%s'", [resource.acl]),
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true
