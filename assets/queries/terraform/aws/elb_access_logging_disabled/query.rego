package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	object.get(resource, "access_logs", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs' is defined", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs' is not defined", [name]),
	}
}

CxPolicy[result] {
	logsEnabled := input.document[i].resource.aws_elb[name].access_logs.enabled
	logsEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[{{%s}}].access_logs.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' is true", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' is false", [name]),
	}
}
