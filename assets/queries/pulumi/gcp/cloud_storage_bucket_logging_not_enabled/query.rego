package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "gcp:storage:Bucket"

	not common_lib.valid_key(resource.properties, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Storage Bucket should have attribute 'logging' defined",
		"keyActualValue": "Storage Bucket attribute 'logging' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}
