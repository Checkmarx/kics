package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticache:Cluster"

	resource.properties.engine == "redis"
	not common_lib.valid_key(resource.properties, "snapshotRetentionLimit")


	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'snapshotRetentionLimit' should be defined and set to higher than 0",
		"keyActualValue": "Attribute 'snapshotRetentionLimit' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticache:Cluster"

	resource.properties.engine == "redis"
	snapshotRetentionLimit := resource.properties.snapshotRetentionLimit
	snapshotRetentionLimit == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.snapshotRetentionLimit", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'snapshotRetentionLimit' should be set to higher than 0",
		"keyActualValue": "Attribute 'snapshotRetentionLimit' is set to 0",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["snapshotRetentionLimit"]),
	}
}
