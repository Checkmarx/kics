package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	not isValidNetworkPolicy(task.azure_rm_aks.network_profile.network_policy)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.azure_rm_aks.network_profile.network_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Azure AKS cluster network policy should be either 'calico' or 'azure'",
		"keyActualValue": sprintf("Azure AKS cluster network policy is %v", [task.azure_rm_aks.network_profile.network_policy]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task.azure_rm_aks, "network_profile", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.azure_rm_aks", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Azure AKS cluster network profile should be defined",
		"keyActualValue": "Azure AKS cluster network profile is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task.azure_rm_aks, "network_profile", "undefined") == "undefined"
	object.get(task.azure_rm_aks.network_profile, "network_policy", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.azure_rm_aks", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Azure AKS cluster network policy should be defined",
		"keyActualValue": "Azure AKS cluster network policy is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isValidNetworkPolicy(policy) {
	policy = "calico"
} else {
	policy = "azure"
} else = false {
	true
}
