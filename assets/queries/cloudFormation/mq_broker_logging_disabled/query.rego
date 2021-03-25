package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	object.get(properties, "Logs", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	object.get(properties, "Logs", "undefined") != "undefined"

    logTypes := ["Audit","General"]

    some j
    object.get(properties.Logs,logTypes[j],"undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Logs", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs.%s is set", [name,logTypes[j]]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs.%s is undefined", [name,logTypes[j]]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	object.get(properties, "Logs", "undefined") != "undefined"

    logTypes := ["Audit","General"]

    some j
    object.get(properties.Logs,logTypes[j],"undefined") != "undefined"
    not object.get(properties.Logs,logTypes[j],"undefined")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Logs.%s", [name,logTypes[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs.%s is true", [name,logTypes[j]]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs.%s is false", [name,logTypes[j]]),
	}
}
