package Cx

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	ports := containers[c].ports
	object.get(ports[k], "hostPort", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.ports", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec[%s].%s[%s].ports[%s].hostPort is not Defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
		"keyActualValue": sprintf("spec[%s].%s[%s].ports[%s].hostPort is Defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec.template.spec
	containers := spec[types[x]]
	ports := containers[c].ports
	object.get(ports[k], "hostPort", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.%s.name=%s.ports", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec[%s].template.spec.%s[%s].ports[%s].hostPort is not Defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
		"keyActualValue": sprintf("spec[%s].template.spec.%s[%s].ports[%s].hostPort is Defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
	}
}
