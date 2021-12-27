package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	not common_lib.valid_key(resource.Properties, "KMSKeyId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KMSKeyId' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KMSKeyId' is undefined or null", [name]),
	}
}
