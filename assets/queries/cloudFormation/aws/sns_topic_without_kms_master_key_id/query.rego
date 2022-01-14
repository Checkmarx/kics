package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SNS::Topic"
	properties := resource.Properties
	not common_lib.valid_key(properties, "KmsMasterKeyId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is undefined", [name]),
	}
}
