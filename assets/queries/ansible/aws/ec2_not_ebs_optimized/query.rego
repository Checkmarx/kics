package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	not common_lib.valid_key(ec2, "ebs_optimized")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2 to have ebs_optimized set to true.",
		"keyActualValue":  "ec2 doesn't have ebs_optimized set to true.",
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	ec2["ebs_optimized"] == false

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2 to have ebs_optimized set to true.",
		"keyActualValue":  "ec2 ebs_optimized is set to false.",
	}
}

