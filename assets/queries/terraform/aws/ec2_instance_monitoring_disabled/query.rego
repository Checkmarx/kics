package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_instance[name]

	not common_lib.valid_key(resource, "monitoring")

	result := {
		"documentId": document.id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'monitoring' should be defined and not null",
		"keyActualValue": "'monitoring' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
		"remediation": "monitoring = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "monitoring")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'monitoring' should be defined and not null",
		"keyActualValue": "'monitoring' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": sprintf("%s = true", [keyToCheck]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_instance[name]

	resource.monitoring == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance.{{%s}}.monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.'monitoring' should be set to true", [name]),
		"keyActualValue": sprintf("%s.'monitoring' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "monitoring"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "monitoring")

	module[keyToCheck] == false

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.'monitoring' should be set to true", [name]),
		"keyActualValue": sprintf("%s.'monitoring' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
