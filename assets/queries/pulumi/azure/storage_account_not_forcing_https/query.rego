package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "azure-native:storage:StorageAccount"

	resource.properties.enableHttpsTrafficOnly == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.enableHttpsTrafficOnly", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Storage Account should have attribute 'enableHttpsTrafficOnly' set to true",
		"keyActualValue": "Storage Account has attribute 'enableHttpsTrafficOnly' set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["enableHttpsTrafficOnly"]),
	}
}
