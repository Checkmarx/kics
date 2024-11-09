package Cx

import data.generic.common as commonLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	document.kind == "PodSecurityPolicy"
	metadata := document.metadata
	spec := document.spec
	not commonLib.compareArrays(spec.requiredDropCapabilities, ["ALL", "NET_RAW"])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.requiredDropCapabilities", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.requiredDropCapabilities 'is ALL or NET_RAW'",
		"keyActualValue": "spec.requiredDropCapabilities 'is not ALL or NET_RAW'",
	}
}
