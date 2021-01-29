package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	ec2Ami := task["amazon.aws.ec2_ami"]
	ec2AmiName := task.name
	devMap := ec2Ami.device_mapping

	object.get(devMap, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_ami}}", [ec2AmiName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.ec2_ami.device_mapping.device_name.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_ami.device_mapping.device_name.encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	ec2Ami := task["amazon.aws.ec2_ami"]
	ec2AmiName := task.name
	devMap := ec2Ami.device_mapping
	not isAnsibleTrue(devMap.encrypted)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_ami}}.device_mapping.encrypted", [ec2AmiName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.ec2_ami.device_mapping.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_ami.device_mapping.encrypted is set to false",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
