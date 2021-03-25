package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Route53::HostedZone"

	object.get(resource.Properties,"QueryLoggingConfig","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.QueryLoggingConfig is set", [name]),
		"keyActualValue": sprintf("Resources.%s.QueryLoggingConfig is undefined", [name]),
	}
}
