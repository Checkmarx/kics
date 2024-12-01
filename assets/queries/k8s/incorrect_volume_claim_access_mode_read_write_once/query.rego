package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	document.kind == "StatefulSet"

	volumeClaims := document.spec.volumeClaimTemplates

	vClaimsWitReadWriteOnce := [vClaims | containsString(volumeClaims[v].spec.accessModes, "ReadWriteOnce") == true; vClaims := volumeClaims[v].metadata.name]
	count(vClaimsWitReadWriteOnce) == 0

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.volumeClaimTemplates", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has one template with a 'ReadWriteOnce'", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates does not have a template with a 'ReadWriteOnce'", [metadata.name]),
	}
}

CxPolicy[result] {
	some document in input.document
	document.kind == "StatefulSet"

	volumeClaims := document.spec.volumeClaimTemplates

	vClaimsWitReadWriteOnce := [vClaims | containsString(volumeClaims[v].spec.accessModes, "ReadWriteOnce") == true; vClaims := volumeClaims[v].metadata.name]
	count(vClaimsWitReadWriteOnce) > 1

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.volumeClaimTemplates", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has only one template with a 'ReadWriteOnce'", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has multiple templates with 'ReadWriteOnce'", [metadata.name]),
	}
}

containsString(array, string) {
	string in array
}
