package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Ingress"
	metadata := document.metadata
	not common_lib.valid_key(document.spec, "tls")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Ingress '%s' should have 'spec.tls' configured", [metadata.name]),
		"keyActualValue": sprintf("Ingress '%s' does not have 'spec.tls' configured; traffic is served over HTTP", [metadata.name]),
		"searchLine": common_lib.build_search_line(["spec"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Ingress"
	metadata := document.metadata
	tls_entries := document.spec.tls
	count(tls_entries) == 0

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.tls", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Ingress '%s' should have at least one TLS entry in 'spec.tls'", [metadata.name]),
		"keyActualValue": sprintf("Ingress '%s' has an empty 'spec.tls' list", [metadata.name]),
		"searchLine": common_lib.build_search_line(["spec", "tls"], []),
	}
}
