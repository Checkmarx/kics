package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"

	object.get(resource.Properties, "LoggingProperties", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingProperties is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingProperties is undefined", [name]),
	}
}
