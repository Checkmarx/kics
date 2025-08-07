package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::MSK::Cluster"
	properties := resources.Properties
	not common_lib.valid_key(properties, "LoggingInfo")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::MSK::Cluster"
	properties := resource.Properties

	properties.LoggingInfo

	not properties.LoggingInfo.BrokerLogs.CloudWatchLogs
	not properties.LoggingInfo.BrokerLogs.Firehose
	not properties.LoggingInfo.BrokerLogs.S3

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs should have at least one of the following keys: 'CloudWatchLogs', 'Firehose' or 'S3'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs 'CloudWatchLogs', 'firehose' and 's3' do not exist", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::MSK::Cluster"
	properties := resource.Properties
	logsName := properties.LoggingInfo.BrokerLogs[log]
	logs := properties.LoggingInfo.BrokerLogs
	not func(logs)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs.%s.Enabled", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs is enabled", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs is disabled", [name]),
	}
}

func(logs) {
	cf_lib.isCloudFormationTrue(logs[_].Enabled)
}
