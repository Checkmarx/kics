package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
	kind == "CronJob"
	not common_lib.valid_key(spec, "startingDeadlineSeconds")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "spec.startingDeadlineSeconds should be defined",
		"keyActualValue": "spec.startingDeadlineSeconds is not defined",
	}
}
