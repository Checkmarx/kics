package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "masterAuth")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth' to be defined and not null",
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
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth.clientCertificateConfig' to be defined and not null",
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
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth.clientCertificateConfig.issueClientCertificate", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'masterAuth.clientCertificateConfig.issueClientCertificate' to be true",
		"keyActualValue": "'masterAuth.clientCertificateConfig.issueClientCertificate' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth", "clientCertificateConfig", "issueClientCertificate"], []),
	}
}
