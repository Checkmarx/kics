package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"

	not common_lib.valid_key(resource.Properties, "LoggingProperties")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingProperties is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingProperties is undefined", [name]),
	}
}
