package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
	kind == "CronJob"
	not common_lib.valid_key(spec, "startingDeadlineSeconds")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "spec.startingDeadlineSeconds should be defined",
		"keyActualValue": "spec.startingDeadlineSeconds is not defined",
	}
}
