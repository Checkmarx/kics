package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

create := "create"

resourceTypes := ["kubernetes_role", "kubernetes_cluster_role"]

pods := "pods"

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule[ru].verbs[l] == create
	resource.rule[ru].resources[_] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"searchValue": sprintf("%s/%s", [create, pods]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule", ru], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule[ru].verbs[l] == create
	ruleResource := resource.rule[ru].resources[_]
	isWildCardValue(ruleResource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"searchValue": sprintf("%s/%s", [create, ruleResource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule", ru], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	verb := resource.rule[ru].verbs[l]
	isWildCardValue(verb)
	resource.rule[ru].resources[_] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, verb]),
		"searchValue": sprintf("%s/%s", [verb, pods]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule", ru], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	verb := resource.rule[ru].verbs[l]
	isWildCardValue(verb)
	ruleResource := resource.rule[ru].resources[_]
	isWildCardValue(ruleResource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, verb]),
		"searchValue": sprintf("%s/%s", [verb, ruleResource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule", ru], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule.verbs[l] == create
	resource.rule.resources[_] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"searchValue": sprintf("%s/%s", [create, pods]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule"], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	resource.rule.verbs[l] == create
	ruleResource := resource.rule.resources[_]
	isWildCardValue(ruleResource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, create]),
		"searchValue": sprintf("%s/%s", [create, ruleResource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the value 'create' when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains the value 'create' and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule"], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	verb := resource.rule.verbs[l]
	isWildCardValue(verb)
	resource.rule.resources[_] == pods

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, verb]),
		"searchValue": sprintf("%s/%s", [verb, pods]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verb should not contain a wildcard value when %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verb contains a wildcard value and %s[%s].rule.resources contains the value 'pods'", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule"], ["verbs", l]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceTypes[t]][name]
	verb := resource.rule.verbs[l]
	isWildCardValue(verb)
	ruleResource := resource.rule.resources[_]
	isWildCardValue(ruleResource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceTypes[t], name, verb]),
		"searchValue": sprintf("%s/%s", [verb, ruleResource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain a wildcard value when %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contains a wildcard value and %s[%s].rule.resources contains a wildcard value", [resourceTypes[t], name, resourceTypes[t], name]),
		"searchLine": common_lib.build_search_line(["resource", resourceTypes[t], name, "rule"], ["verbs", l]),
	}
}

isWildCardValue(val) {
	regex.match(".*\\*.*", val)
}
