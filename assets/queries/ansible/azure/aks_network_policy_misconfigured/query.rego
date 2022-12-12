package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib


modules := {"azure.azcollection.azure_rm_aks", "azure_rm_aks"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not isValidNetworkPolicy(aks.network_profile.network_policy)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_profile.network_policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Azure AKS cluster network policy should be either 'calico' or 'azure'",
		"keyActualValue": sprintf("Azure AKS cluster network policy is %v", [aks.network_profile.network_policy]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not common_lib.valid_key(aks, "network_profile")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Azure AKS cluster network profile should be defined",
		"keyActualValue": "Azure AKS cluster network profile is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not common_lib.valid_key(aks.network_profile, "network_policy")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Azure AKS cluster network policy should be defined",
		"keyActualValue": "Azure AKS cluster network policy is undefined",
	}
}

isValidNetworkPolicy(policy) {
	policy = "calico"
} else {
	policy = "azure"
} else = false {
	true
}
