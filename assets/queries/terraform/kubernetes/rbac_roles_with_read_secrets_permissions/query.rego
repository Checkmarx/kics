package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

readVerbs := ["get", "watch", "list"]

CxPolicy[result] {
	resourceTypes := ["kubernetes_role", "kubernetes_cluster_role"]
	resource := input.document[i].resource[resourceTypes[t]][name]
	allowsSecrets(resource.rule)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceTypes[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule", [resourceTypes[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Rules don't give access to 'secrets' resources",
		"keyActualValue": "Some rule is giving access to 'secrets' resources",
	}
}

allowsSecrets(rules) {
	is_array(rules)
	some r
	"secrets" in rules[r].resources
	rules[r].verbs[_] == readVerbs[_]
}

allowsSecrets(rule) {
	is_object(rule)
	"secrets" in rule.resources
	rule.verbs[_] == readVerbs[_]
}
