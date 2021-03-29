package Cx

CxPolicy[result] {
	resourceTypes := ["kubernetes_role", "kubernetes_cluster_role"]
	resource := input.document[i].resource[resourceTypes[t]][name]
	readVerbs := ["get", "watch", "list"]
	resource.rule[ru].resources[r] == "secrets"
	resource.rule[ru].verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule", [resourceTypes[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Rules don't give access to 'secrets' resources",
		"keyActualValue": "Some rule is giving access to 'secrets' resources",
	}
}
