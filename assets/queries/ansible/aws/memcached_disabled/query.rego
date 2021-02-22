package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	task["community.aws.elasticache"].engine == "redis"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.elasticache}}.engine", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.elasticache}}.engine enables Memcached", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.elasticache}}.engine doesn't enable Memcached", [task.name]),
	}
}