package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	not k8sLib.startWithFlag(container,"--client-ca-file")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue":  "Client Certification should be set",
		"keyActualValue": "Client Certification is not set",
        "searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

command = {"kube-apiserver", "kubelet"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
    cmd := command[_]
	common_lib.inArray(container.command, cmd)
    k8sLib.startWithFlag(container,"--client-ca-file")
	not	k8sLib.startAndEndWithFlag(container,"--client-ca-file", ".crt")
	not	k8sLib.startAndEndWithFlag(container,"--client-ca-file", ".pem")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Client Certification should have a .pem or .crt file",
		"keyActualValue": "Client Certification is not properly set",
        "searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    notValidClientCAFile(doc)

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}",
		"issueType": "MissingAttribute",
		"keyExpectedValue":  "Client Certification should be set",
		"keyActualValue": "Client Certification is not set",
	}
}

notValidClientCAFile(doc){
	not common_lib.valid_key(doc, "authentication")
} else {
	not common_lib.valid_key(doc.authentication,"x509")
} else {
	not common_lib.valid_key(doc.authentication.x509,"clientCAFile")
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    not endswith(doc.authentication.x509.clientCAFile, ".pem")
    not endswith(doc.authentication.x509.clientCAFile, ".crt")
	 
	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}",
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Client Certification should have a .pem or .crt file",
		"keyActualValue":  "Client Certification is not properly set",
	}
}
