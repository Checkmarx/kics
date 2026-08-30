package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:backup:Vault"
	properties := resource.properties
	not common_lib.valid_key(properties, "kmsKeyArn")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties"],[]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws:backup:Vault.kmsKeyArn should be defined",
		"keyActualValue": "aws:backup:Vault.kmsKeyArn is undefined",
	}
}
