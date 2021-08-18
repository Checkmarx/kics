package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_config_configuration_aggregator[name]
	resource[type].all_regions != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_config_configuration_aggregator[%s].%s.all_regions", [name, type]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_db_instance[%s].%s.all_regions' is set to true", [name, type]),
		"keyActualValue": sprintf("'aws_db_instance[%s].%s.all_regions' is set to false", [name, type]),
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
		"searchKey": sprintf("aws_config_configuration_aggregator[%s].%s", [name, type]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_db_instance[%s].%s.all_regions' is set to true", [name, type]),
		"keyActualValue": sprintf("'aws_db_instance[%s].%s.all_regions' is undefined", [name, type]),
	}
}
