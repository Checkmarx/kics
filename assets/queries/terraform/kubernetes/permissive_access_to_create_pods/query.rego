package Cx

import data.generic.terraform as tf_lib

create := "create"

resourceTypes := ["kubernetes_role", "kubernetes_cluster_role"]

pods := "pods"

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule[ru].verbs[l] == create
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule[ru].verbs[l] == create
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	isWildCardValue(resource.rule[ru].verbs[l])
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	isWildCardValue(resource.rule[ru].verbs[l])
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule.verbs[l] == create
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule.verbs[l] == create
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	isWildCardValue(resource.rule.verbs[l])
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verb should not contain a wildcard value when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verb contains a wildcard value and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	isWildCardValue(resource.rule.verbs[l])
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
	}
}

isWildCardValue(val) {
	regex.match(".*\\*.*", val)
}
