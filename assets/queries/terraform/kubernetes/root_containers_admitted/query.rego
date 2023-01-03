package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	privilege := {"privileged", "allow_privilege_escalation"}

	resource.spec[privilege[p]] == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.%s", [name, privilege[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s should be set to false", [name, privilege[p]]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s is set to true", [name, privilege[p]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.run_as_user.rule != "MustRunAsNonRoot"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.run_as_user.rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.run_as_user.rule is equal to 'MustRunAsNonRoot'", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.run_as_user.rule is not equal to 'MustRunAsNonRoot'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	groups := {"fs_group", "supplemental_groups"}

	resource.spec[groups[p]].rule != "MustRunAs"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.%s.rule", [name, groups[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s.rule limits its ranges", [name, groups[p]]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s.rule does not limit its ranges", [name, groups[p]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	groups := {"fs_group", "supplemental_groups"}

	resource.spec[groups[p]].rule == "MustRunAs"
	resource.spec[groups[p]].range.min == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.%s.range.min", [name, groups[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s.range.min should not allow range '0' (root)", [name, groups[p]]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.%s.range.min allows range '0' (root)", [name, groups[p]]),
	}
}
