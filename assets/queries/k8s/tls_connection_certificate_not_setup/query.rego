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
	not startWithFlag(container,tls)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
				"keyExpectedValue": sprintf( "TLS %s conenction setting should be set", [tls]),
		"keyActualValue": sprintf("TLS %s connection not set", [tls]),
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
		"searchKey": sprintf("kind={{%s}}", ["KubeletConfiguration"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf( "TLS %s conenction setting should be set", [tls]),
		"keyActualValue": sprintf("TLS %s connection not set", [tls]),
	}
}


startWithFlag(container, flag){
	inArrayStartsWith(container.command, flag)
} else {
	inArrayStartsWith(container.args, flag)
}

inArrayStartsWith(list, item) {
	some i
    startswith(list[i], item)
}
