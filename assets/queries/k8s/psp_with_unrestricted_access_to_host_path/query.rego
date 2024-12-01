package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	document.kind == "PodSecurityPolicy"

	not common_lib.valid_key(document.spec, "allowedHostPaths")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'spec.allowedHostPaths' should be defined and not null",
		"keyActualValue": "'spec.allowedHostPaths' is undefined or null",
		"searchLine": common_lib.build_search_line(["spec"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	document.kind == "PodSecurityPolicy"

	hostPath := document.spec.allowedHostPaths[idx]
	not common_lib.valid_key(hostPath, "readOnly")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.allowedHostPaths", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.allowedHostPaths[%d].readOnly' should be set to true", [idx]),
		"keyActualValue": sprintf("'spec.allowedHostPaths[%d].readOnly' is undefined or null", [idx]),
		"searchLine": common_lib.build_search_line(["spec", "allowedHostPaths"], [idx]),
	}
}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	document.kind == "PodSecurityPolicy"

	hostPath := document.spec.allowedHostPaths[idx]
	hostPath.readOnly != true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.allowedHostPaths.readOnly", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.allowedHostPaths[%d].readOnly' should be set to true", [idx]),
		"keyActualValue": sprintf("'spec.allowedHostPaths[%d].readOnly' is set to false", [idx]),
		"searchLine": common_lib.build_search_line(["spec", "allowedHostPaths", idx], ["readOnly"]),
	}
}
