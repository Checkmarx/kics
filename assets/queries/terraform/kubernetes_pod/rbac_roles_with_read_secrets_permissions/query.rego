package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	readVerbs := ["get", "watch", "list"]
	resource[name].rule[ru].resources[r] == "secrets"
	resource[name].rule[ru].verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Roles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("Roles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource[name].rule[ru].verbs)]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	readVerbs := ["get", "watch", "list"]
	resource[name].rule.resources[r] == "secrets"
	resource[name].rule.verbs[j] == readVerbs[k]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Roles should not be allowed to send read verbs to 'secrets' resources",
		"keyActualValue": sprintf("Roles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource[name].rule.verbs)]),
	}
}
