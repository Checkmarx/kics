package Cx

import data.generic.k8s as k8s_lib
import data.generic.common as common_lib

tlsFlagList := {"--tls-cert-file", "--tls-private-key-file"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8s_lib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	tls :=  tlsFlagList[_]
	common_lib.inArray(container.command, "kube-apiserver")
	not k8s_lib.startWithFlag(container,tls)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf( "TLS %s connection setting should be set", [tls]),
		"keyActualValue": sprintf("TLS %s connection not set", [tls]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

tlsList := {"tlsCertFile", "tlsPrivateKeyFile"}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    tls :=  tlsList[_]
    not common_lib.valid_key(doc, tls)

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": sprintf("kind={{%s}}", ["KubeletConfiguration"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf( "TLS %s connection setting should be set", [tls]),
		"keyActualValue": sprintf("TLS %s connection not set", [tls]),
	}
}
