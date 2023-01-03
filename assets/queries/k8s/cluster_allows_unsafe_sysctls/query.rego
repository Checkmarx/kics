package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	spec.allowedUnsafeSysctls

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.allowedUnsafeSysctls", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.allowedUnsafeSysctls should be undefined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.allowedUnsafeSysctls is defined", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	sysctl := specInfo.spec.securityContext.sysctls[_].name
	check_unsafe(sysctl)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.sysctls.name={{%s}}", [metadata.name, specInfo.path, sysctl]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.sysctls.name={{%s}} should not be used", [metadata.name, specInfo.path, sysctl]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.sysctls.name={{%s}} is an unsafe sysctl", [metadata.name, specInfo.path, sysctl]),
	}
}

check_unsafe(sysctl) {
	safeSysctls := {
		"kernel.shm_rmid_forced", "kernel/shm_rmid_forced",
		"net.ipv4.ip_local_port_range", "net/ipv4/ip_local_port_range",
		"net.ipv4.ip_unprivileged_port_start", "net/ipv4/ip_unprivileged_port_start",
		"net.ipv4.tcp_syncookies", "net/ipv4/tcp_syncookies",
		"net.ipv4.ping_group_range", "net/ipv4/tcp_syncookies",
	}
	not safeSysctls[sysctl]
}
