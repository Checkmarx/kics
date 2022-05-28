package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}
options := {"runAsUser", "runAsNonRoot"}

runsAsRoot(ctx) {
	runAsNonRoot := object.get(ctx, "runAsNonRoot", false)
	runAsUser := object.get(ctx, "runAsUser", 0)

	runAsNonRoot == false
	to_number(runAsUser) == 0
}

# container defines runAsNonRoot or runAsUser
checkRoot(specInfo, container, containerType, containerId, document, metadata) = result {
	common_lib.valid_key(container.securityContext, options[_])
	runsAsRoot(container.securityContext)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser", [metadata.name, specInfo.path, containerType, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

# container inherits setting from pod
checkRoot(specInfo, container, containerType, containerId, document, metadata) = result {
	containerCtx := object.get(container, "securityContext", {})
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
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path]),
	}
}

# neither pod nor container define runAsNonRoot or runAsUser
checkRoot(specInfo, container, containerType, containerId, document, metadata) = result {
	specCtx := object.get(specInfo.spec, "securityContext", {})
	not common_lib.valid_key(specCtx, "runAsUser")
	not common_lib.valid_key(specCtx, "runAsNonRoot")

	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "runAsUser")
	not common_lib.valid_key(containerCtx, "runAsNonRoot")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, containerType, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, containerType, container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [containerType, containerId, "securityContext"])
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	result := checkRoot(specInfo, specInfo.spec[types[x]][c], types[x], c, document, metadata)
}
