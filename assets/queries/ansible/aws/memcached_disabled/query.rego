package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.elasticache"].engine == "redis"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.elasticache}}.engine", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.elasticache}}.engine enables Memcached", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.elasticache}}.engine doesn't enable Memcached", [task.name]),
	}
}
