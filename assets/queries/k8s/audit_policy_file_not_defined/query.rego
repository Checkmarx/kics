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
	not k8sLib.startWithFlag(container, "--audit-policy-file")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--audit-policy-file flag should be defined",
		"keyActualValue": "--audit-policy-file is not defined",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	k8sLib.startWithFlag(container, "--audit-policy-file")
	file := getFlagFile(container, "--audit-policy-file")
    not hasPolicyFile(input, file)


	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--audit-policy-file flag should have a valid file",
		"keyActualValue": "--audit-policy-file does not have a valid file",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

getFlagFile(container, flag) = file{
	file:= startsWithGetPath(container.command, flag)
} else = file{
	file:= startsWithGetPath(container.args, flag)
}

startsWithGetPath(arr, item) = file {
    startswith(arr[i], item)
	path := split(arr[i], "=")[1]
	filePath:= split(path, "/")
	endswith(filePath[j], ".yaml")
	file:= filePath[j]
}

hasPolicyFile(inputData, file){
	inputData.document[i].kind == "Policy"
    contains(inputData.document[i].file, file)
}
