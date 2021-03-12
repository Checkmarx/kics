package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
    kind := document.kind
    listKinds :=  ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec

	metadata := document.metadata
	result := checkRootParent(spec, "spec", metadata, input.document[i].id)
}

CxPolicy[result] {
	document := input.document[i]
    kind := document.kind
    listKinds :=  ["CronJob"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec.jobTemplate.spec.template.spec

	metadata := document.metadata
	result := checkRootParent(spec, "spec.jobTemplate.spec.template.spec", metadata, input.document[i].id)
}

CxPolicy[result] {
	document := input.document[i]
    kind := document.kind
    listKinds :=  ["Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec.template.spec

	metadata := document.metadata
	result := checkRootParent(spec, "spec.template.spec", metadata, input.document[i].id)
}

checkRootParent(spec, path, metadata, id) = result {
	nonRootParent := object.get(spec.securityContext, "runAsNonRoot", "undefined")
	is_boolean(nonRootParent)

	nonRootParent == true

	result := checkRootContainer(spec, path, metadata, id)
}

checkRootParent(spec, path, metadata, id) = result {
	nonRootParent := object.get(spec.securityContext, "runAsNonRoot", "undefined")
	is_boolean(nonRootParent)

	nonRootParent == false

	userParent := object.get(spec.securityContext, "runAsUser", "undefined")
	is_number(userParent)

	userParent > 0

	result := checkUserContainer(spec, path, metadata, id)
}

checkRootParent(spec, path, metadata, id) = result {
	object.get(spec.securityContext, "runAsNonRoot", "undefined") == "undefined"
	object.get(spec.securityContext, "runAsUser", "undefined") == "undefined"

	result := checkRootContainer(spec, path, metadata, id)
}

checkRootContainer(spec, path, metadata, id) = result {
	some j
	types = {"initContainers", "containers"}
	container := spec[types[x]][j]
	not container.securityContext.runAsNonRoot
	uid := container.securityContext.runAsUser
	to_number(uid) <= 0

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.%s", [metadata.name, path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true", [path, types[x], j]),
		"keyActualValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true", [path, types[x], j]),
	}
}

checkRootContainer(spec, path, metadata, id) = result {
	some j
	types = {"initContainers", "containers"}
	container := spec[types[x]][j]
	not container.securityContext.runAsNonRoot
	object.get(container.securityContext, "runAsUser", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.{{%s}}.securityContext", [metadata.name, path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is defined", [path, types[x], j]),
		"keyActualValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is undefined", [path, types[x], j]),
	}
}

checkUserContainer(spec, path, metadata, id) = result {
	some j
	types = {"initContainers", "containers"}
	container := spec[types[x]][j]
	uid := container.securityContext.runAsUser
	to_number(uid) <= 0

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.%s", [metadata.name, path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true", [path, types[x], j]),
		"keyActualValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true", [path, types[x], j]),
	}
}

checkUserContainer(spec, path, metadata, id) = result {
	some j
	types = {"initContainers", "containers"}
	container := spec[types[x]][j]
	not container.securityContext.runAsNonRoot
	object.get(container.securityContext, "runAsUser", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.{{%s}}.securityContext", [metadata.name, path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is defined", [path, types[x], j]),
		"keyActualValue": sprintf("'%s.%s[%d].securityContext.runAsUser' is undefined", [path, types[x], j]),

	}
}
