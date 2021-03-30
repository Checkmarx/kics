package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	policy := s3_bucket.policy
	policy.Statement[ix].Effect = "Allow"

	action := policy.Statement[ix].Action
	commonLib.containsOrInArrayContains(action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'Effect' is 'Allow'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'Effect' is 'Allow'",
	}
}
