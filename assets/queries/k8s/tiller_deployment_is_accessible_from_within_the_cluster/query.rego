package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]

	isTiller(document)

	container := document.spec[types[x]][j]
	metadata := document.metadata

	contains(container.image, "tiller")

	not common_lib.valid_key(container, "args")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.%s", [metadata.name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.%s[%s].args' should be set", [types[x], container.name]),
		"keyActualValue": sprintf("'spec.%s[%s].args' is undefined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	isTiller(document)

	container := document.spec[types[x]][j]
	metadata := document.metadata

	contains(container.image, "tiller")

	not common_lib.valid_key(container, "args")

	not listenLocal(container.args)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.%s.args", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.%s[%s].args' sets the container to listen to localhost", [types[x], container.name]),
		"keyActualValue": sprintf("'spec.%s[%s].args' is not setting the container to listen to localhost", [types[x], container.name]),
	}
}

#template container
CxPolicy[result] {
	document := input.document[i]

	isTillerTemplate(document)

	container := document.spec.template.spec[types[x]][j]
	metadata := document.metadata

	not common_lib.valid_key(container, "args")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.%s", [metadata.name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.template.spec.%s[%s].args' should be set", [types[x], container.name]),
		"keyActualValue": sprintf("'spec.template.spec.%s[%s].args' is undefined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	isTillerTemplate(document)

	container := document.spec.template.spec[types[x]][j]
	metadata := document.metadata

	common_lib.valid_key(container, "args")
	not listenLocal(container.args)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.%s.args", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.%s[%s].args' sets the container to listen to localhost", [types[x], container.name]),
		"keyActualValue": sprintf("'spec.template.spec.%s[%s].args' is not setting the container to listen to localhost", [types[x], container.name]),
	}
}

############################################################
isTiller(document) {
	document.spec.containers
	checkMetadata(document.metadata)
}

isTillerTemplate(document) {
	document.spec.template.spec.containers
	checkMetadata(document.spec.template.metadata)
}

##############################################################

listenLocal(args) {
	some j
	arg := args[j]
	is_string(arg)
	contains(arg, "--listen")
	localAddress(arg)
}

localAddress(arg) {
	contains(arg, "localhost")
}

localAddress(arg) {
	contains(arg, "127.0.0.1")
}

checkMetadata(metadata) {
	contains(metadata.name, "tiller")
}

checkMetadata(metadata) {
	object.get(metadata.labels, "app", "undefined") == "helm"
}

checkMetadata(metadata) {
	contains(object.get(metadata.labels, "name", "undefined"), "tiller")
}
