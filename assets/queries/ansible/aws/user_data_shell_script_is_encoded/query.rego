package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	user_data := task["community.aws.ec2_lc"].user_data

	decode_result := check_user_data(user_data)
	startswith(decode_result, "#!/")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.user_data", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data is not shell script", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data is shell script", [task.name]),
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
