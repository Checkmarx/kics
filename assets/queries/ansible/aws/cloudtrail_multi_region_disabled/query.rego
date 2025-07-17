package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	common_lib.valid_key(cloudtrail, "is_multi_region_trail")
	ansLib.isAnsibleFalse(cloudtrail.is_multi_region_trail)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.is_multi_region_trail", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudtrail.is_multi_region_trail should be true",
		"keyActualValue": "cloudtrail.is_multi_region_trail is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	not common_lib.valid_key(cloudtrail, "is_multi_region_trail")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudtrail.is_multi_region_trail should be defined and set to true",
		"keyActualValue": "cloudtrail.is_multi_region_trail is undefined",
	}
}
