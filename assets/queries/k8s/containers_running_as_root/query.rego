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
checkRoot(specInfo, container, containerType, document, metadata) = result {
	common_lib.valid_key(container.securityContext, options[_])
	runsAsRoot(container.securityContext)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser", [metadata.name, specInfo.path, containerType, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

# container inherits setting from pod
checkRoot(specInfo, container, containerType, document, metadata) = result {
	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "runAsUser")
	not common_lib.valid_key(containerCtx, "runAsNonRoot")

	common_lib.valid_key(specInfo.spec.securityContext, options[_])
	runsAsRoot(specInfo.spec.securityContext)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path]),
	}
}

# neither pod nor container define runAsNonRoot or runAsUser
checkRoot(specInfo, container, containerType, document, metadata) = result {
	specCtx := object.get(specInfo.spec, "securityContext", {})
	not common_lib.valid_key(specCtx, "runAsUser")
	not common_lib.valid_key(specCtx, "runAsNonRoot")

	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "runAsUser")
	not common_lib.valid_key(containerCtx, "runAsNonRoot")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext", [metadata.name, specInfo.path, containerType, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is higher than 0 and/or 'runAsNonRoot' is true", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is 0 and 'runAsNonRoot' is false", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	result := checkRoot(specInfo, specInfo.spec[types[x]][_], types[x], document, metadata)
}
