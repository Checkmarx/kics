package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	common_lib.valid_key(resource.spec, "allowed_unsafe_sysctls")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls should be undefined", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls is set", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	sysctl := resource.spec.security_context.sysctl[x].name
	check_unsafe(sysctl)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.security_context.sysctl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.security_context.sysctl[%s].name should not have an unsafe sysctl", [name, x]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.security_context.sysctl[%s].name has an unsafe sysctl", [name, x]),
	}
}

check_unsafe(sysctl) {
	safeSysctls = {"kernel.shm_rmid_forced", "net.ipv4.ip_local_port_range", "net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}
	not safeSysctls[sysctl]
}
