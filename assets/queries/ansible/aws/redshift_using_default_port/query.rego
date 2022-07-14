package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib 

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"redshift", "community.aws.redshift"}

	task[modules[m]].port == 5439

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.port should not be set to 5439",
		"keyActualValue": "redshift.port is set to 5439",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "port"], []),
	}
}
