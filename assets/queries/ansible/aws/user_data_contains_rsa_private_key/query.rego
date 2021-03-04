package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	user_data := task["community.aws.ec2_lc"].user_data

	contains(user_data, "LS0tLS1CR")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.user_data", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data should not contain RSA Private Key", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data contains RSA Private Key", [task.name]),
	}
}
