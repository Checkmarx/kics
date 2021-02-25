package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3 := task["amazon.aws.aws_s3"]

	hasPublicReadPermission(s3.permission)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.aws_s3}}.permission", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.aws_s3 should not have read access for all user groups",
		"keyActualValue": "amazon.aws.aws_s3 has read access for all user groups",
	}
}

hasPublicReadPermission(value) {
	startswith(value, "public-read")
}
