package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task["community.aws.cloudfront_distribution"]

	object.get(cloudfront, "logging", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}} logging is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}} logging is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task["community.aws.cloudfront_distribution"]
	loggingE := cloudfront.logging

	not ansLib.isAnsibleTrue(loggingE.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled", [task.name2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled is true", [task.name2]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled is false", [task.name2]),
	}
}
