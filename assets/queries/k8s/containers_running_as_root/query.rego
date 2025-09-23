package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}
options := {"runAsUser", "runAsNonRoot"}

## container defines runAsNonRoot or runAsUser
CxPolicy[result] {
    document := input.document[i]
    metadata := document.metadata

    specInfo := k8sLib.getSpecInfo(document)

	common_lib.valid_key(specInfo.spec[types[x]][c].securityContext, options[_])
	runsAsRoot(specInfo.spec[types[x]][c].securityContext)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext"])
	}
}

# container inherits setting from pod
CxPolicy[result] {
    document := input.document[i]
    metadata := document.metadata

    specInfo := k8sLib.getSpecInfo(document)

	containerCtx := object.get(specInfo.spec[types[x]][c], "securityContext", {})
	not common_lib.valid_key(containerCtx, "runAsUser")
	not common_lib.valid_key(containerCtx, "runAsNonRoot")

	common_lib.valid_key(specInfo.spec.securityContext, options[_])
	runsAsRoot(specInfo.spec.securityContext)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["securityContext"]),
	}
}


## neither pod nor container define runAsNonRoot or runAsUser
CxPolicy[result] {
    document := input.document[i]
    metadata := document.metadata

    specInfo := k8sLib.getSpecInfo(document)

	specCtx := object.get(specInfo.spec, "securityContext", {})
	not common_lib.valid_key(specCtx, "runAsUser")
	not common_lib.valid_key(specCtx, "runAsNonRoot")

	containerCtx := object.get(specInfo.spec[types[x]][c], "securityContext", {})
	not common_lib.valid_key(containerCtx, "runAsUser")
	not common_lib.valid_key(containerCtx, "runAsNonRoot")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c])
	}
}

runsAsRoot(ctx) {
	runAsNonRoot := object.get(ctx, "runAsNonRoot", false)
	runAsUser := object.get(ctx, "runAsUser", 0)

	runAsNonRoot == false
	to_number(runAsUser) == 0
}
