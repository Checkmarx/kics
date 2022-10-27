package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name]

	not common_lib.valid_key(resource, "attributes")

	result := {
		"documentId": document.id,
		"resourceType": "aws_globalaccelerator_accelerator",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_globalaccelerator_accelerator", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is undefined or null", [name]),
		"remediation": "attributes {\n\t\t flow_logs_enabled = true \n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_globalaccelerator_accelerator[name].attributes

	not common_lib.valid_key(resource, "flow_logs_enabled")

	result := {
		"documentId": document.id,
		"resourceType": "aws_globalaccelerator_accelerator",
		"resourceName": tf_lib.get_resource_name(document.resource.aws_globalaccelerator_accelerator[name], name),
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].attributes", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_globalaccelerator_accelerator", name, "attributes"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is undefined or null", [name]),
		"remediation": "flow_logs_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	document := input.document[i]
	logs := document.resource.aws_globalaccelerator_accelerator[name].attributes.flow_logs_enabled

	logs == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_globalaccelerator_accelerator",
		"resourceName": tf_lib.get_resource_name(document.resource.aws_globalaccelerator_accelerator[name], name),
		"searchKey": sprintf("aws_globalaccelerator_accelerator[{{%s}}].attributes.flow_logs_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_globalaccelerator_accelerator", name, "attributes", "flow_logs_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled should be true", [name]),
		"keyActualValue": sprintf("aws_globalaccelerator_accelerator[{{%s}}].flow_logs_enabled is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
