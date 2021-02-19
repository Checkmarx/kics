package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ec2_instance"].publicly_accessible)
	user_data := task["community.aws.ec2_instance"].user_data

	re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", user_data)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_instance}}.user_data", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.ec2_instance.user_data' doesn't contain access key",
		"keyActualValue": "'community.aws.ec2_instance.user_data' contains access key",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ec2_instance"].publicly_accessible)
	user_data := task["community.aws.ec2_instance"].user_data

	re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", user_data)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_instance}}.user_data", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.ec2_instance.user_data' doesn't contain access key",
		"keyActualValue": "'community.aws.ec2_instance.user_data' contains access key",
	}
}

