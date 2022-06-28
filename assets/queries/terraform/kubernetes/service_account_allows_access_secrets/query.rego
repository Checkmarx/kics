package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resources_types := ["kubernetes_role", "kubernetes_cluster_role"]
	resource := input.document[i].resource[resources_types[type]]
    ruleTaint := ["get", "watch", "list", "*"]
    kind := resources_types[type]
    getName := resource[name]
    bindingExists(name, kind)

	contentRule(resource[name].rule, ruleTaint)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources_types[type],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].rule", [resources_types[type], name]),
	    "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].rule.verbs should not contain the following verbs: %s", [resources_types[type], name, ruleTaint]),
		"keyActualValue": sprintf("%s[%s].rule.verbs contain one of the following verbs: %s", [resources_types[type], name, ruleTaint]),
	}
}

bindingExists(name, kind) {
	kind == "kubernetes_role"

    resource = input.document[roleBinding].resource.kubernetes_role_binding[kcr_name]
	resource.subject[s].kind == "ServiceAccount"
	resource.role_ref.kind == "Role"
	resource.role_ref.name == name
} else {
	kind == "kubernetes_cluster_role"

    resource = input.document[roleBinding].resource.kubernetes_cluster_role_binding[kcr_name]
	resource.subject[s].kind == "ServiceAccount"
	resource.role_ref.kind == "ClusterRole"
	resource.role_ref.name == name
}

contentRule(rule, ruleTaint) {
    resources := rule.resources
	resources[_] == "secrets"

	verbs := rule.verbs
	commonLib.compareArrays(ruleTaint, verbs)
}

contentRule(rule, ruleTaint) {
	is_array(rule)
    resources := rule[r].resources
	resources[_] == "secrets"

	verbs := rule[r].verbs
	commonLib.compareArrays(ruleTaint, verbs)
}

