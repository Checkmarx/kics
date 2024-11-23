package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	document.kind == "PodSecurityPolicy"
	metadata := document.metadata
	spec := document.spec
	not common_lib.valid_key(spec, "requiredDropCapabilities")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.requiredDropCapabilities should be defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.requiredDropCapabilities is undefined", [metadata.name]),
	}
}
