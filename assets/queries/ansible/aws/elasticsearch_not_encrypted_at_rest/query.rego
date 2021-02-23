package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	elasticsearch = tasks[_][j]
	elasticsearchBody = elasticsearch.ec2_elasticsearch
	elasticsearchName = elasticsearchBody.name
	is_disabled(elasticsearchBody.encryption_at_rest_enabled)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{encryption_at_rest_enabled}}", [elasticsearchName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.encryption_at_rest_enabled should be enabled", [elasticsearchName]),
		"keyActualValue": sprintf("name={{%s}}.encryption_at_rest_enabled is disabled", [elasticsearchName]),
	}
}

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	elasticsearch = tasks[_][j]
	elasticsearchBody = elasticsearch.ec2_elasticsearch
	elasticsearchName = elasticsearchBody.name
	object.get(elasticsearchBody, "encryption_at_rest_enabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}", [elasticsearchName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.encryption_at_rest_enabled should be set and enabled", [elasticsearchName]),
		"keyActualValue": sprintf("name={{%s}}.encryption_at_rest_enabled is undefined", [elasticsearchName]),
	}
}

is_disabled(value) {
	negativeValue = {"False", false, "false", "No", "no"}
	value == negativeValue[_]
} else = false {
	true
}

