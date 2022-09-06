package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticache:Cluster"

	resource.properties.engine == "memcached"
	resource.properties.numCacheNodes >1
	not common_lib.valid_key(resource.properties, "azMode")


	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'azMode' should be defined and set to 'cross-az' in multi nodes cluster",
		"keyActualValue": "Attribute 'azMode' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticache:Cluster"

	resource.properties.engine == "memcached"
	resource.properties.numCacheNodes >1
	resource.properties.azMode != "cross-az"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.azMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'azMode' should be set to 'cross-az' in multi nodes cluster",
		"keyActualValue": sprintf("Attribute 'azMode' is set to %s", [resource.properties.azMode]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["azMode"]),
	}
}
