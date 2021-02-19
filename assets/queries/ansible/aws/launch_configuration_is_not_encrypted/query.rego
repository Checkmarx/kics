package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ec2_lc"].publicly_accessible)
	cluster := task["community.aws.ec2_lc"]
	clusterName := task.name

	volumes := cluster.volumes
	volume := volumes[v]
	object.get(volume, "encrypted", "undefined") == "undefined"
	deviceName := volume.device_name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.volumes.device_name={{%s}}", [clusterName, deviceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
		"keyActualValue": "community.aws.redshift.encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ec2_lc"].publicly_accessible)
	cluster := task["community.aws.ec2_lc"]
	clusterName := task.name

	volumes := cluster.volumes
	volume := volumes[v]

	not isAnsibleTrue(volume.encrypted)
	deviceName := volume.device_name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.volumes.device_name={{%s}}.encrypted", [clusterName, deviceName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.ec2_lc.volumes[*].encrypted should be set to true",
		"keyActualValue": "community.aws.ec2_lc.volumes[*].encrypted is set to false",
	}
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
