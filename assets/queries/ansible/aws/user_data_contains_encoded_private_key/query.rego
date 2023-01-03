package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_lc", "ec2_lc"}
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	contains(ec2_lc.user_data, "LS0tLS1CR")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.user_data", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_lc.user_data should not contain RSA Private Key",
		"keyActualValue": "ec2_lc.user_data contains RSA Private Key",
	}
}
