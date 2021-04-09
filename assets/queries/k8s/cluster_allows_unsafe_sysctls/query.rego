package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	spec.allowedUnsafeSysctls

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s.spec", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.allowedUnsafeSysctls is undefined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.allowedUnsafeSysctls is defined", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	spec := document.spec

	sysctl := spec.securityContext.sysctls[_].name
	check_unsafe(sysctl)

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s.spec.securityContext.sysctls", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.securityContext.sysctls does not have an unsafe sysctl", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.securityContext.sysctls has an unsafe sysctl", [metadata.name]),
	}
}

check_unsafe(sysctl) {
	safeSysctls = {"kernel.shm_rmid_forced", "net.ipv4.ip_local_port_range", "net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}
	not safeSysctls[sysctl]
}
