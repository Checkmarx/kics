package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	not common_lib.valid_key(resource, "access_logs")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs' is defined and not null", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs' is undefined or null", [name]),
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
