package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::MSK::Cluster"

	properties := resource.Properties
	object.get(properties, "EncryptionInfo", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionInfo is defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionInfo is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::MSK::Cluster"

	properties := resource.Properties
	properties.EncryptionInfo.EncryptionInTransit.ClientBroker != "TLS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.ClientBroker", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.ClientBroker is 'TLS'", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.ClientBroker is not 'TLS'", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::MSK::Cluster"

	properties := resource.Properties
	isResFalse(properties.EncryptionInfo.EncryptionInTransit.InCluster)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster is 'true'", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster is 'false'", [key]),
	}
}

isResFalse(answer) {
	answer == "false"
} else {
	answer == false
}
