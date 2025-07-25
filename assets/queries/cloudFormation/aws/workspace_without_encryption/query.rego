package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	some workspaceName
	document.Resources[workspaceName].Type == "AWS::WorkSpaces::Workspace"
	workspace := document.Resources[workspaceName]

	# The UserVolumeEncryptionEnabled property is defined, but is not set to true
	not cf_lib.isCloudFormationTrue(workspace.Properties.UserVolumeEncryptionEnabled)

	result := {
		"documentId": document.id,
		"resourceType": document.Resources[workspaceName].Type,
		"resourceName": cf_lib.get_resource_name(document.Resources[workspaceName], workspaceName),
		"searchKey": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled", [workspaceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled should be set to true", [workspaceName]),
		"keyActualValue": sprintf("Resources.%s.Properties.UserVolumeEncryptionEnabled is not set to true", [workspaceName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	some workspaceName
	document.Resources[workspaceName].Type == "AWS::WorkSpaces::Workspace"
	workspace := document.Resources[workspaceName]

	# The UserVolumeEncryptionEnabled property is not defined
	not common_lib.valid_key(workspace.Properties, "UserVolumeEncryptionEnabled")

	result := {
		"documentId": document.id,
		"resourceType": document.Resources[workspaceName].Type,
		"resourceName": cf_lib.get_resource_name(document.Resources[workspaceName], workspaceName),
		"searchKey": sprintf("Resources.%s.Properties", [workspaceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties should have the property UserVolumeEncryptionEnabled set to true", [workspaceName]),
		"keyActualValue": sprintf("Resources.%s.Properties does not have the UserVolumeEncryptionEnabled property set", [workspaceName]),
	}
}

