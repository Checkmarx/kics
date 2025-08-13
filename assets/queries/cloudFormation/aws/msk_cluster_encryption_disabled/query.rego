package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::MSK::Cluster"

	properties := resource.Properties
	not common_lib.valid_key(properties, "EncryptionInfo")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionInfo should be defined", [key]),
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
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
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
	cf_lib.isCloudFormationFalse(properties.EncryptionInfo.EncryptionInTransit.InCluster)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster is 'true'", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionInfo.EncryptionInTransit.InCluster is 'false'", [key]),
	}
}

