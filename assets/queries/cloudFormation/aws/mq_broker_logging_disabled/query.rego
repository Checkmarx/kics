package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Logs")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	common_lib.valid_key(properties, "Logs")

    logTypes := ["Audit","General"]
	lTypes := logTypes[j]
    not common_lib.valid_key(properties.Logs,lTypes)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Logs", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs.%s should be set", [name,lTypes]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs.%s is undefined", [name,lTypes]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties
	common_lib.valid_key(properties, "Logs")

    logTypes := ["Audit","General"]

    common_lib.valid_key(properties.Logs,logTypes[j])
	cf_lib.isCloudFormationFalse(properties.Logs[logTypes[j]])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Logs.%s", [name,logTypes[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Logs.%s is true", [name,logTypes[j]]),
		"keyActualValue": sprintf("Resources.%s.Properties.Logs.%s is false", [name,logTypes[j]]),
	}
}
