package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "gcp:compute:SSLPolicy"

	not common_lib.valid_key(resource.properties, "minTlsVersion")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "SSLPolicy should have 'minTlsVersion' defined and set to 'TLS_1_2'",
		"keyActualValue": "SSLPolicy 'minTlsVersion' attribute is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "gcp:compute:SSLPolicy"

	resource.properties.minTlsVersion != "TLS_1_2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.minTlsVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SSLPolicy should have 'minTlsVersion' set to 'TLS_1_2'",
		"keyActualValue": sprintf("SSLPolicy 'minTlsVersion' attribute is set to %s", [resource.properties.minTlsVersion]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["minTlsVersion"]),
	}
}
