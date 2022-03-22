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
	not correctExtention(container,"--client-ca-file", ".pem")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Client Certification should have a .pem file",
		"keyActualValue": "Client Certification is not properly set",
        "searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    notValidClientCAFile(doc.authentication)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("kind={{%s}}", ["KubeletConfiguration"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue":  "Client Certification should be set",
		"keyActualValue": "Client Certification is not set",
	}
}

notValidClientCAFile(authentication){
	not common_lib.valid_key(authentication,"x509")
}else{
	not common_lib.valid_key(authentication.x509,"clientCAFile")
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    not endswith(doc.authentication.x509.clientCAFile, ".pem")
	 
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("kind={{%s}}", ["KubeletConfiguration"]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Client Certification should have a .pem file",
		"keyActualValue":  "Client Certification is not properly set",
	}
}

correctExtention(container, flag, ext){
	startsWithAndEndsWithArray(container.command, flag,ext)
} else {
	startsWithAndEndsWithArray(container.args, flag, ext)
}

startsWithAndEndsWithArray(arr, item, ext) {
    startswith(arr[_], item)
    endswith(arr[_], ext)
}
