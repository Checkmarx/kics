package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	
	common_lib.valid_key(document, "cniVersion")
	plugin := document.plugins[j]
	plugin.type == "flannel"

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("plugins", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Plugins should not contain a plugin that does not support Network Policies",
		"keyActualValue": "Plugins contains a plugin that does not support Network Policies",
		"searchLine": common_lib.build_search_line(["plugins", j, "type"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "ConfigMap"
	
	cni:= json.unmarshal(document.data["cni-conf.json"])
    plugin := cni.plugins[j]
    plugin.type == "flannel"

	result := {
		"documentId": document.id,
		"resourceType": "ConfigMap",
		"resourceName": document.metadata.name,
		"searchKey": sprintf("data.cni-conf.json", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Plugins should not contain a plugin that does not support Network Policies",
		"keyActualValue": "Plugins contains a plugin that does not support Network Policies",
		"searchLine": common_lib.build_search_line(["data", "cni-conf.json"], []),
	}
}

