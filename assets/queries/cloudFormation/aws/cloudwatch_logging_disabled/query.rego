package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Route53::HostedZone"

	not common_lib.valid_key(resource.Properties,"QueryLoggingConfig")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.QueryLoggingConfig is set", [name]),
		"keyActualValue": sprintf("Resources.%s.QueryLoggingConfig is undefined", [name]),
	}
}
