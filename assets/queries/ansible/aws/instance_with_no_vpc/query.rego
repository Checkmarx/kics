package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ec2_instance", "amazon.aws.ec2"].publicly_accessible)
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