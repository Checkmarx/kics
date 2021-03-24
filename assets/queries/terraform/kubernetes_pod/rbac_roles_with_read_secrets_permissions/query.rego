package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	readVerbs := ["get", "watch", "list"]
	resource.rule[ru].resources[r] == "secrets"
	resource.rule[ru].verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role.%s.rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Roles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("Roles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rule[ru].verbs)]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	readVerbs := ["get", "watch", "list"]
	resource.rule.resources[r] == "secrets"
	resource.rule.verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role.%s.rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Roles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("Roles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rule.verbs)]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	readVerbs := ["get", "watch", "list"]
	resource.rule[ru].resources[r] == "secrets"
	resource.rule[ru].verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role.%s.rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ClusterRoles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("ClusterRoles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rule[ru].verbs)]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	readVerbs := ["get", "watch", "list"]
	resource.rule.resources[r] == "secrets"
	resource.rule.verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role.%s.rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ClusterRoles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("ClusterRoles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rule.verbs)]),
	}
}
