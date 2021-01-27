package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	volumeClaims := input.document[i].spec.volumeClaimTemplates

	vClaimsWitReadWriteOnce := [vClaims | contains(volumeClaims[v].spec.accessModes, "ReadWriteOnce") == true; vClaims := volumeClaims[v].metadata.name]
	count(vClaimsWitReadWriteOnce) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.volumeClaimTemplates", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has one template with a 'ReadWriteOnce'", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates does not have a template with a 'ReadWriteOnce'", [metadata.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	volumeClaims := input.document[i].spec.volumeClaimTemplates

	vClaimsWitReadWriteOnce := [vClaims | contains(volumeClaims[v].spec.accessModes, "ReadWriteOnce") == true; vClaims := volumeClaims[v].metadata.name]
	count(vClaimsWitReadWriteOnce) > 1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.volumeClaimTemplates", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has only one template with a 'ReadWriteOnce'", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.volumeClaimTemplates has multiple templates with 'ReadWriteOnce'", [metadata.name]),
	}
}

contains(array, string) {
	array[_] == string
}
