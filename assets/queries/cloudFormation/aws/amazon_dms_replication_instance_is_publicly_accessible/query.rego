package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::DMS::ReplicationInstance"
	properties := resource.Properties
	cf_lib.isCloudFormationTrue(properties.PubliclyAccessible)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PubliclyAccessible should be defined to 'false'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PubliclyAccessible is defined to 'true", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PubliclyAccessible"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::DMS::ReplicationInstance"
	properties := resource.Properties
	not common_lib.valid_key(properties, "PubliclyAccessible")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PubliclyAccessible should be defined to 'false'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PubliclyAccessible is not defined", [name]),
	}
}