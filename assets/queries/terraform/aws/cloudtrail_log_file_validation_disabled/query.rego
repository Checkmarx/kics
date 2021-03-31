package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]
	resource.enable_log_file_validation == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s].enable_log_file_validation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_cloudtrail[%s].enable_log_file_validation' is true", [name]),
		"keyActualValue": sprintf("'aws_cloudtrail[%s].enable_log_file_validation' is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]
	object.get(resource, "enable_log_file_validation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_cloudtrail[%s].enable_log_file_validation' is set", [name]),
		"keyActualValue": sprintf("'aws_cloudtrail[%s].enable_log_file_validation' is undefined", [name]),
	}
}
