package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	object.get(resource, "monitoring", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance.%s.monitoring should be defined", [name]),
		"keyActualValue": sprintf("aws_instance.%s.monitoring is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	resource.monitoring == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}.monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance.%s.monitoring should be true", [name]),
		"keyActualValue": sprintf("aws_instance.%s.monitoring is false", [name]),
	}
}
