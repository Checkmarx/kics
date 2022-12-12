package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"
	not common_lib.valid_key(resource.Properties, "Port")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Port' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Port' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"
	resource.Properties.Port == 5439

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Port' should not be set to 5439", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Port' is set to 5439", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Port"], []),
	}
}
