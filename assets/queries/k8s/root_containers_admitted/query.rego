package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	privilege := {"privileged", "allowPrivilegeEscalation"}

	spec[privilege[p]] == true

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s", [metadata.name, privilege[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s should be set to 'false'", [metadata.name, privilege[p]]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s is set to 'true'", [metadata.name, privilege[p]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	spec.runAsUser.rule != "MustRunAsNonRoot"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.runAsUser.rule", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.runAsUser.rule is equal to 'MustRunAsNonRoot'", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.runAsUser.rule is not equal to 'MustRunAsNonRoot'", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec
	groups := {"fsGroup", "supplementalGroups"}

	spec[groups[p]].rule != "MustRunAs"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.rule", [metadata.name, groups[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s limits its ranges", [metadata.name, groups[p]]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s does not limit its ranges", [metadata.name, groups[p]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec
	groups := {"fsGroup", "supplementalGroups"}

	spec[groups[p]].rule == "MustRunAs"
	spec[groups[p]].ranges[_].min == 0

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s", [metadata.name, groups[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name{{%s}}.spec.%s should not allow range '0' (root)", [metadata.name, groups[p]]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s allows range '0' (root)", [metadata.name, groups[p]]),
	}
}
