package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	policy := s3_bucket.policy
	policy.Statement[ix].Effect = "Allow"

	action := policy.Statement[ix].Action
	is_string(action)
	contains(action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Statement", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'Effect' is 'Allow'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'Effect' is 'Allow'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	policy := s3_bucket.policy
	policy.Statement[ix].Effect = "Allow"

	action := policy.Statement[ix].Action
	is_array(action)
	contains(action[_], "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Action' doesn't contain '*' when 'Effect' is 'Allow'",
		"keyActualValue": "'policy.Statement.Action' contains '*' when 'Effect' is 'Allow'",
	}
}
