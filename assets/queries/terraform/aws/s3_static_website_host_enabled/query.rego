package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	count(resource.website) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_s3_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_s3_bucket[%s].website doesn't have static websites inside", [name]),
		"keyActualValue": sprintf("resource.aws_s3_bucket[%s].website does have static websites inside", [name]),
	}
}
