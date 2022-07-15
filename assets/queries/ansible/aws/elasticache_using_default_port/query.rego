package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.elasticache", "elasticache"}
	elasticache := task[modules[m]]
	ans_lib.checkState(elasticache)

	engines := {"memcached": 11211, "redis": 6379}
	enginePort := engines[e]

	elasticache.engine == e
	elasticache.cache_port == enginePort

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.cache_port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'cache_port' should not be set to %d", [enginePort]),
		"keyActualValue": sprintf("'cache_port' is set to %d", [enginePort]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "cache_port"], []),
	}
}
