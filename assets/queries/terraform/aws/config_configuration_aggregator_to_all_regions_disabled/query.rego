package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_config_configuration_aggregator[name]
	resource[type].all_regions != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_config_configuration_aggregator",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_config_configuration_aggregator[%s].%s.all_regions", [name, type]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_config_configuration_aggregator[%s].%s.all_regions' should be set to true", [name, type]),
		"keyActualValue": sprintf("'aws_config_configuration_aggregator[%s].%s.all_regions' is set to false", [name, type]),
		"searchLine": common_lib.build_search_line(["resource", "aws_config_configuration_aggregator", name, type, "all_regions"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_config_configuration_aggregator[name]
	options := {"account_aggregation_source", "organization_aggregation_source"}
    type := options[o]
	resourceElement := resource[type]

	not common_lib.valid_key(resourceElement, "all_regions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_config_configuration_aggregator",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_config_configuration_aggregator[%s].%s", [name, type]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_config_configuration_aggregator[%s].%s.all_regions' should be set to true", [name, type]),
		"keyActualValue": sprintf("'aws_config_configuration_aggregator[%s].%s.all_regions' is undefined", [name, type]),
		"searchLine": common_lib.build_search_line(["resource", "aws_config_configuration_aggregator", name, type], []),
		"remediation": "all_regions = true",
		"remediationType": "addition",
	}
}
