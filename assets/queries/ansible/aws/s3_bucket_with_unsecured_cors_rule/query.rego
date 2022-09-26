package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.aws_s3_cors", "aws_s3_cors"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	cors := task[modules[m]]
	ans_lib.checkState(cors)

	rule := cors.rules[c]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%d] should not allow all methods, all headers or several origins", [modules[m], c]),
		"keyActualValue": sprintf("%s[%d] allows all methods, all headers or several origins", [modules[m], c]),
	}
}
