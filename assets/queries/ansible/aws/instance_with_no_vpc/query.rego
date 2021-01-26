package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	modules := {"community.aws.ec2_instance", "amazon.aws.ec2"}

	object.get(task[modules[index]], "vpc_subnet_id", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.vpc_subnet_id is set", [modules[index]]),
		"keyActualValue": sprintf("%s.vpc_subnet_id is undefined", [modules[index]]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
