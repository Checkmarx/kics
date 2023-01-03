package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ec2:Instance"

	not common_lib.valid_key(resource.properties, "monitoring")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'monitoring' should be defined and set to true",
		"keyActualValue": "Attribute 'monitoring' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ec2:Instance"

	monitoring := resource.properties.monitoring
	monitoring == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'monitoring' should be set to true",
		"keyActualValue": "Attribute 'monitoring' is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["monitoring"]),
	}
}
