package Cx

import data.generic.common as common_lib
import future.keywords.in

types := {"initContainers", "containers"}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	ports := containers[c].ports
	common_lib.valid_key(ports[k], "hostPort")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.ports", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec[%s].%s[%s].ports[%s].hostPort should not be defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
		"keyActualValue": sprintf("spec[%s].%s[%s].ports[%s].hostPort is defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
	}
}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	spec := document.spec.template.spec
	containers := spec[types[x]]
	ports := containers[c].ports
	common_lib.valid_key(ports[k], "hostPort")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.%s.name=%s.ports", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec[%s].template.spec.%s[%s].ports[%s].hostPort should not be defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
		"keyActualValue": sprintf("spec[%s].template.spec.%s[%s].ports[%s].hostPort is defined", [metadata.name, types[x], containers[c].name, ports[k].hostIP]),
	}
}
