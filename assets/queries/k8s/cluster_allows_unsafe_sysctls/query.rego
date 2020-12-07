package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  input.document[i].kind == "PodSecurityPolicy"
  spec := input.document[i].spec

  spec.allowedUnsafeSysctls

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.allowedUnsafeSysctls is undefined", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.allowedUnsafeSysctls is defined", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  input.document[i].kind == "Pod"
  spec := input.document[i].spec
  
  sysctl := spec.securityContext.sysctls[_].name
  check_Unsafe(sysctl)

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.securityContext.sysctls", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.securityContext.sysctls does not have an Unsafe Sysctl", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.securityContext.sysctls has an Unsafe Sysctl", [metadata.name])
              }
}

check_Unsafe(sysctl) {
	safeSysctls = {"kernel.shm_rmid_forced", "net.ipv4.ip_local_port_range", "net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}
    not safeSysctls[sysctl]
}
