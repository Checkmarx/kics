package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.privileged == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.privileged", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.privileged is set to 'false'", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.privileged is set to 'true'", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.allowPrivilegeEscalation == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.allowPrivilegeEscalation", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.allowPrivilegeEscalation is set to 'false'", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.allowPrivilegeEscalation is set to 'true'", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.readOnlyRootFilesystem == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.readOnlyRootFilesystem", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.readOnlyRootFilesystem is set to 'false'", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.readOnlyRootFilesystem is set to 'true'", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.runAsUser.rule != "MustRunAsNonRoot"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.runAsUser.rule", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.runAsUser.rule is equal to 'MustRunAsNonRoot'", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.runAsUser.rule is not equal to 'MustRunAsNonRoot'", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.supplementalGroups.rule != "MustRunAs"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.supplementalGroups.rule", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.supplementalGroups limits its ranges", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.supplementalGroups does not limit its ranges", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.supplementalGroups.rule == "MustRunAs"
  spec.supplementalGroups.ranges[_].min == 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.supplementalGroups", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.supplementalGroups does not allow range '0' (root)", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.supplementalGroups allows range '0' (root)", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.fsGroup.rule != "MustRunAs"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.fsGroup.rule", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.fsGroup limits its ranges", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.fsGroup does not limit its ranges", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  input.document[i].kind == "PodSecurityPolicy"
  spec.fsGroup.rule == "MustRunAs"
  spec.fsGroup.ranges[_].min == 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.fsGroup", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.fsGroup does not allow range '0'", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.fsGroup allows range '0'", [metadata.name])
              }
}