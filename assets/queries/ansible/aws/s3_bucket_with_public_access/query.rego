package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	contains(task["amazon.aws.aws_s3"].permission, "public")

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.aws_s3}}.permission", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon_aws_aws_s3.permission is %s", [task["amazon.aws.aws_s3"].permission]),
		"keyActualValue": "amazon_aws_aws_s3.permission allows public access",
	}
}
