package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name]

	object.get(resource, "attributes", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is defined", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name].attributes

	object.get(resource, "flow_logs_enabled", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].attributes", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is defined", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	logs := document.resource.aws_globalaccelerator_accelerator[name].attributes.flow_logs_enabled

	logs == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled", [name]),
		"issueType": "IncorretValue",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is true", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is false", [name]),
	}
}
