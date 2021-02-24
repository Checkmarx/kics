package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3 := task["amazon.aws.aws_s3"]

	s3.permission == "authenticated-read"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.aws_s3}}.permission", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.aws_s3 should not have read access for all authenticated users",
		"keyActualValue": "amazon.aws.aws_s3 has read access for all authenticated users",
	}
}
