package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.elasticache", "elasticache"}
	elasticache := task[modules[m]]
	ans_lib.checkState(elasticache)

	not common_lib.valid_key(elasticache, "cache_subnet_group")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cache_subnet_group' should be defined and not null",
		"keyActualValue": "'cache_subnet_group' is undefined or null",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}
