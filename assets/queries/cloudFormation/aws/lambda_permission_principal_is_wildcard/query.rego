package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	properties := resource.Properties
	contains(properties.Principal, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Principal", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Principal is not wildcard", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Principal is wildcard", [name]),
	}
}
