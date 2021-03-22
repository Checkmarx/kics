package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_lc", "ec2_lc"}
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	decode_result := check_user_data(ec2_lc.user_data)
	startswith(decode_result, "#!/")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.user_data", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_lc.user_data is not shell script",
		"keyActualValue": "ec2_lc.user_data is shell script",
	}
}

check_user_data(user_data) = result {
	user_data == null
	result := base64.decode("dGVzdA==") #test
}

check_user_data(user_data) = result {
	user_data != null
	result := base64.decode(user_data)
}
