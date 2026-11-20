package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Backup::BackupVault"
	not common_lib.valid_key(resource.Properties, "EncryptionKeyArn")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionKeyArn should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionKeyArn is not defined", [name]),
	}
}
