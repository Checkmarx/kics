package Cx

CxPolicy[result] {
	s3 := input.document[i].resource.aws_s3_bucket[name]
	not s3.logging

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].logging", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' exists",
		"keyActualValue": "'logging' is missing",
	}
}
