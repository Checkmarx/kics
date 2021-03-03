package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["amazon.aws.s3_bucket"].policy
	statement := policy.Statement[_]

	statement.Principal == "*"
	statement.Effect == "Allow"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement doesn't make the bucket accessible to all AWS Accounts", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement does make the bucket accessible to all AWS Accounts", [task.name]),
	}
}
