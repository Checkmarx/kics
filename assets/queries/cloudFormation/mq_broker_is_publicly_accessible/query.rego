package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	object.get(properties, "PubliclyAccessible", "undefined") != "undefined"

    properties.PubliclyAccessible

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PubliclyAccessible is false or undefined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PubliclyAccessible is true", [name]),
	}
}
