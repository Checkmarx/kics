package Cx

import data.generic.k8s as k8s_lib
import data.generic.common as common_lib

strongCiphersConfig = [
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
]

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8s_lib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	not k8s_lib.startWithFlag(container,"--tls-cipher-suites")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue":  "'--tls-cipher-suites' flag should be defined and use strong ciphers",
		"keyActualValue": "'--tls-cipher-suites' flag is not defined",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

command = {"kube-apiserver", "kubelet"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8s_lib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
    cmd := command[_]
	common_lib.inArray(container.command, cmd)
    hasWeakCipher(container,"--tls-cipher-suites")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "TLS cipher suites should use strong ciphers",
		"keyActualValue": "TLS cipher suites uses a weak cipher",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    not common_lib.valid_key(doc, "tlsCipherSuites")

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "KubeletConfiguration should have 'tlsCipherSuites' attribute with strong ciphers defined",
		"keyActualValue": "TLS cipher suites are not defined",
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
	cipher := doc.tlsCipherSuites[_]
    not common_lib.inArray(strongCiphersConfig,cipher)
	 
	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.tlsCipherSuites",
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "TLS cipher suites should use strong ciphers",
		"keyActualValue": "TLS cipher suites uses a weak cipher",
	}
}

hasWeakCipher(container,flag){
	cipherSplit(container.command, flag)
} else {
	cipherSplit(container.args, flag)
}

cipherSplit(arr,item){
	element := arr[_]
	startswith(element, item)
    options := split(element, "=")
    ciphers := split(options[1], ",")
    cipher := ciphers[_]
    not common_lib.inArray(strongCiphersConfig,cipher)
}
