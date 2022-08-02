package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "azure-native:cache:Redis"

	resource.properties.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.enableNonSslPort", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Redis Cache should have attribute 'enableNonSslPort' set to false",
		"keyActualValue": "Redis Cache has attribute 'enableNonSslPort' set to true",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["enableNonSslPort"]),
	}
}
