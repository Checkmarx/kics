package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	properties.MultiAZ == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MultiAZ", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' has MultiAZ value set to false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not common_lib.valid_key(properties, "MultiAZ")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' MultiAZ property is undefined and by default disabled", [name]),
	}
}
