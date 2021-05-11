package Cx

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

	object.get(resource[type], "all_regions", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_config_configuration_aggregator[%s].%s", [name, type]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_db_instance[%s].%s.all_regions' is set to true", [name, type]),
		"keyActualValue": sprintf("'aws_db_instance[%s].%s.all_regions' is undefined", [name, type]),
	}
}
