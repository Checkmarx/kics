package Cx

# container
CxPolicy[result] {
	document := input.document[i]

	isTiller(document)

	container := document.spec.containers[j]
	metadata := document.metadata

	contains(container.image, "tiller")

	object.get(container, "args", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.containers[%s].args' is set", [container.name]),
		"keyActualValue": sprintf("'spec.containers[%s].args' is undefined", [container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	isTiller(document)

	container := document.spec.containers[j]
	metadata := document.metadata

	contains(container.image, "tiller")

	object.get(container, "args", "undefined") != "undefined"

	not listenLocal(container.args)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.args", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.containers[%s].args' set the container to listen to localhost", [container.name]),
		"keyActualValue": sprintf("'spec.containers[%s].args' is not setting the container to lister to localhost", [container.name]),
	}
}

#template container
CxPolicy[result] {
	document := input.document[i]

	isTillerTemplate(document)

	container := document.spec.template.spec.containers[j]
	metadata := document.metadata

	object.get(container, "args", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.containers", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.template.spec.containers[%s].args' is set", [container.name]),
		"keyActualValue": sprintf("'spec.template.spec.containers[%s].args' is undefined", [container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	isTillerTemplate(document)

	container := document.spec.template.spec.containers[j]
	metadata := document.metadata

	object.get(container, "args", "undefined") != "undefined"
	not listenLocal(container.args)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.containers.args", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.containers[%s].args' set the container to listen to localhost", [container.name]),
		"keyActualValue": sprintf("'spec.template.spec.containers[%s].args' is not setting the container to lister to localhost", [container.name]),
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

checkMetadata(metadata) {
	contains(metadata.name, "tiller")
}

checkMetadata(metadata) {
	object.get(metadata.labels, "app", "undefined") == "helm"
}

checkMetadata(metadata) {
	contains(object.get(metadata.labels, "name", "undefined"), "tiller")
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
