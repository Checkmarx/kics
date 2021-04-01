package Cx

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	object.get(cloudtrail, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].kms_key_id is defined", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].kms_key_id is undefined", [name]),
	}
}
