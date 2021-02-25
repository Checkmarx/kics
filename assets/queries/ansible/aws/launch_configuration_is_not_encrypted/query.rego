package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["community.aws.ec2_lc"]
	volumes := cluster.volumes
	volume := volumes[v]

	object.get(volume, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.volumes.device_name={{%s}}", [task.name, volume.device_name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
		"keyActualValue": "community.aws.redshift.encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["community.aws.ec2_lc"]
	volumes := cluster.volumes
	volume := volumes[v]

	not ansLib.isAnsibleTrue(volume.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ec2_lc}}.volumes.device_name={{%s}}.encrypted", [task.name, volume.device_name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.ec2_lc.volumes[*].encrypted should be set to true",
		"keyActualValue": "community.aws.ec2_lc.volumes[*].encrypted is set to false",
	}
}
