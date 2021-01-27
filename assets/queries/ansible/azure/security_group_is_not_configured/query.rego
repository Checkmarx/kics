package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	subnet := task.azure_rm_subnet
	subnetName := task.name

	object.get(subnet, "security_group", "undefined") == "undefined"
	object.get(subnet, "security_group_name", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}", [subnetName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_subnet.security_group is defined",
		"keyActualValue": "azure_rm_subnet.security_group is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	subnet := task.azure_rm_subnet
	subnetName := task.name

	checkString(subnet.security_group)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}.security_group", [subnetName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group is not empty or null",
		"keyActualValue": "azure_rm_subnet.security_group is empty or null",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	subnet := task.azure_rm_subnet
	subnetName := task.name

	checkString(subnet.security_group_name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}.security_group_name", [subnetName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group_name is not empty or null",
		"keyActualValue": "azure_rm_subnet.security_group_name is empty or null",
	}
}

checkString(string) {
	string == null
}

checkString(string) {
	count(string) == 0
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
