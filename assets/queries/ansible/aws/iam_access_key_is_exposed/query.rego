package Cx

CxPolicy[result] {
	document = input.document[i]
	tasks := getTasks(document)
	iamuserObj = tasks[_]
	iamuserObjBody = iamuserObj["community.aws.iam"]
	iamuserObjName = iamuserObj.name
	lower(iamuserObjBody.access_key_state) == "active"
	contains(lower(iamuserObjBody.name),"root")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam}}.access_key_state", [iamuserObjName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.{{community.aws.iam}}.name is 'root' for an active access key", [iamuserObjName]),
		"keyActualValue": sprintf("{{%s}}.{{community.aws.iam}}.name is '%s' for an active access key", [iamuserObjName, iamuserObjBody.name]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
