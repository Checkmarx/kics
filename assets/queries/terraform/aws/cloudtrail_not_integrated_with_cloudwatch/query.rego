package Cx

CxPolicy[result] {
	document := input.document[i]
	cloudtrail := document.resource.aws_cloudtrail[name]
	attr := {"cloud_watch_logs_role_arn", "cloud_watch_logs_group_arn"}

	object.get(cloudtrail, attr[a], "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].%s is defined", [name, attr[a]]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].%s is not defined", [name, attr[a]]),
	}
}
