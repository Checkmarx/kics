package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	resource.properties.iamConfiguration.uniformBucketLevelAccess.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.iamConfiguration.uniformBucketLevelAccess.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enabled' should be set to true",
		"keyActualValue": "'enabled' is set to false",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "iamConfiguration", "uniformBucketLevelAccess", "enabled"], []),
	}
}
