package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	not isValidNetworkPolicy(task.azure_rm_aks.network_profile.network_policy)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.azure_rm_aks.network_profile.network_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Azure AKS cluster network policy should be either 'calico' or 'azure'",
		"keyActualValue": sprintf("Azure AKS cluster network policy is %v", [task.azure_rm_aks.network_profile.network_policy]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_aks, "network_profile", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.azure_rm_aks", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Azure AKS cluster network profile should be defined",
		"keyActualValue": "Azure AKS cluster network profile is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_aks, "network_profile", "undefined") == "undefined"
	object.get(task.azure_rm_aks.network_profile, "network_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.azure_rm_aks", [task.name]),
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
