package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	min_version_string = "4.0.10"
	eval_version_number(task["community.aws.elasticache"].cache_engine_version) < eval_version_number(min_version_string)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version is compliant with the AWS PCI DSS requirements", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version isn't compliant with the AWS PCI DSS requirements", [task.name]),
	}
}

eval_version_number(engine_version) = numeric_version {
	version = split(engine_version, ".")
	numeric_version = ((to_number(version[0]) * 100) + (to_number(version[1]) * 10)) + to_number(version[2])
}
