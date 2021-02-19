package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_vol"].publicly_accessible)
	volume := task["amazon.aws.ec2_vol"]
	volumeName := task.name

	object.get(volume, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}", [volumeName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_vol.encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_vol"].publicly_accessible)
	volume := task["amazon.aws.ec2_vol"]
	volumeName := task.name

	not isAnsibleTrue(volume.encrypted)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}.encrypt", [volumeName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_vol.encrypted is set to false",
	}
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
