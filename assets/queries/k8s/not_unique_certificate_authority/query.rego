package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8s_lib


CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
    specInfo := k8s_lib.getSpecInfo(resource)
    types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
    common_lib.inArray(container.command, "etcd")
	trusted_path := getTrustedPath(container)
    resource_aux := input.document[_]
    client_path := getClientPath(resource_aux)
    trusted_path == client_path

	result := {
        "documentId": input.document[i].id,
        "resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Trusted Certificate Authentication File should not be the same of a Client Certificate Authentication File",
		"keyActualValue": "Trusted Certificate Authentication File is the same of a Client Certificate Authentication File",
        "searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

getTrustedPath(container) = path{    
    path:= split(flagValue(container, "--trusted-ca-file"),"=")[1]
    
}

flagValue(container, flag) = val{
	val:=getFlag(container.command, flag)
} else =  val{
	val:=getFlag(container.args, flag)
}

getFlag(arr, item) = array_item {
    array_item = arr[_]
    startswith(array_item, item)
}

getClientPath(resource) = path {
    specInfo := k8s_lib.getSpecInfo(resource)
    types := {"initContainers", "containers"}
    container := specInfo.spec[types[x]][j]
    common_lib.inArray(container.command, "kube-apiserver")
    path:= split(flagValue(container, "--client-ca-file"),"=")[1]    
}
