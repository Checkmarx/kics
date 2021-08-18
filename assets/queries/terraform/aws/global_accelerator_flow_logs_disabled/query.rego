package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name]

	not common_lib.valid_key(resource, "attributes")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is defined and not null", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name].attributes

	not common_lib.valid_key(resource, "flow_logs_enabled")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].attributes", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is defined and not null", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	logs := document.resource.aws_globalaccelerator_accelerator[name].attributes.flow_logs_enabled

	logs == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is true", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is false", [name]),
	}
}
