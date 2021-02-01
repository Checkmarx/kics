package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	role = "authenticated-read"
	resource.acl == role

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].acl is private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].acl is %s", [name, role]),
	}
}
