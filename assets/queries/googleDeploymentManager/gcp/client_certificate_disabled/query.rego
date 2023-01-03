package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "masterAuth")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth' should be defined and not null",
		"keyActualValue": "'masterAuth' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.masterAuth, "clientCertificateConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth.clientCertificateConfig' should be defined and not null",
		"keyActualValue": "'masterAuth.clientCertificateConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.masterAuth.clientCertificateConfig.issueClientCertificate == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth.clientCertificateConfig.issueClientCertificate", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'masterAuth.clientCertificateConfig.issueClientCertificate' should be true",
		"keyActualValue": "'masterAuth.clientCertificateConfig.issueClientCertificate' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth", "clientCertificateConfig", "issueClientCertificate"], []),
	}
}
