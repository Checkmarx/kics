package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.elasticache", "elasticache"}
	elasticache := task[modules[m]]
	ansLib.checkState(elasticache)

	elasticache.engine == "redis"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.engine", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "elasticache.engine to have Memcached enabled",
		"keyActualValue": "elasticache.engine doesn't enable Memcached",
	}
}
