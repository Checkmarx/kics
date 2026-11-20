package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	broker := input.document[i].resource.aws_mq_broker[name]
	logs := broker.logs

	categories := ["general", "audit"]

	some j
	type := categories[j]
	logs[type] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_mq_broker",
		"resourceName": tf_lib.get_specific_resource_name(broker, "aws_mq_broker", name),
		"searchKey": sprintf("aws_mq_broker[%s].logs.%s", [name, type]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'general' and 'audit' logging should be set to true",
		"keyActualValue": sprintf("'%s' is set to false", [type]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	broker := input.document[i].resource.aws_mq_broker[name]
	logs := broker.logs

	categories := ["general", "audit"]

	some j
	type := categories[j]
	not has_key(logs, type)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_mq_broker",
		"resourceName": tf_lib.get_specific_resource_name(broker, "aws_mq_broker", name),
		"searchKey": sprintf("aws_mq_broker[%s].logs", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'general' and 'audit' logging should be set to true",
		"keyActualValue": "'general' and/or 'audit' is undefined",
		"remediation": sprintf("%s = true", [type]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	broker := input.document[i].resource.aws_mq_broker[name]

	not broker.logs

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_mq_broker",
		"resourceName": tf_lib.get_specific_resource_name(broker, "aws_mq_broker", name),
		"searchKey": sprintf("aws_mq_broker[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logs' should be set and enabling general AND audit logging",
		"keyActualValue": "'logs' is undefined",
		"remediation": "logs {\n\t\tgeneral = true\n\t\taudit   = true\n\t}",
		"remediationType": "addition",
	}
}

has_key(obj, key) {
	_ = obj[key]
}
