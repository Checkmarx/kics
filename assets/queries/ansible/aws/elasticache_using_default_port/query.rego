package Cx

import data.generic.ansible as ans_lib

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
		"searchKey": sprintf("name={{%s}}.{{%s}}.cache_port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'cache_port' is not set to %d", [enginePort]),
		"keyActualValue": sprintf("'cache_port' is set to %d", [enginePort]),
	}
}
