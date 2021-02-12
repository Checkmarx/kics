package Cx

CxPolicy[result] {
	document := input.document[i]
	some workspaceName
	document.Resources[policyName].Type == "AWS::WorkSpaces::Workspace"
	workspace := document.Resources[workspaceName]

	# The UserVolumeEncryptionEnabled property is defined, but is set to false
	object.get(workspace.Properties, "UserVolumeEncryptionEnabled", "undefined") != "undefined"
	not isTrue(workspace.Properties.UserVolumeEncryptionEnabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled", [workspaceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled should be set to true", [workspaceName]),
		"keyActualValue": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled is set to false", [workspaceName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	some workspaceName
	document.Resources[policyName].Type == "AWS::WorkSpaces::Workspace"
	workspace := document.Resources[workspaceName]

	# The UserVolumeEncryptionEnabled property is not defined
	object.get(workspace.Properties, "UserVolumeEncryptionEnabled", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [workspaceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties should have the property UserVolumeEncryptionEnabled set to true", [workspaceName]),
		"keyActualValue": sprintf("Resources.%s.Properties does not have the UserVolumeEncryptionEnabled property set", [workspaceName]),
	}
}

isTrue(true) = true

isTrue("true") = true
