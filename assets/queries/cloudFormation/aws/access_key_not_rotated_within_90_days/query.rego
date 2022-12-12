package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::Config::ConfigRule"
	not hasAccessKeyRotationRule(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s should have a ConfigRule defining rotation period on AccessKeys.", [name]),
		"keyActualValue": sprintf("Resources.%s doesn't have a ConfigRule defining rotation period on AccessKeys.", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	configRule := document.Resources[name]
	configRule.Type == "AWS::Config::ConfigRule"
	configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"

	not common_lib.valid_key(configRule.Properties, "InputParameters")

	result := {
		"documentId": document.id,
		"resourceType": configRule.Type,
		"resourceName": cf_lib.get_resource_name(configRule, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.InputParameters should be defined and contain 'maxAccessKeyAge' key.", [name]),
		"keyActualValue": sprintf("Resources.%s.InputParameters is undefined.", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	configRule := document.Resources[name]
	configRule.Type == "AWS::Config::ConfigRule"
	configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"

	maxDays := configRule.Properties.InputParameters.maxAccessKeyAge

	to_number(maxDays) > 90

	result := {
		"documentId": document.id,
		"resourceType": configRule.Type,
		"resourceName": cf_lib.get_resource_name(configRule, name),
		"searchKey": sprintf("Resources.%s.Properties.InputParameters.maxAccessKeyAge", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.InputParameters.maxAccessKeyAge should be less or equal to 90 (days)", [name]),
		"keyActualValue": sprintf("Resources.%s.InputParameters.maxAccessKeyAge is more than 90 (days).", [name]),
	}
}

hasAccessKeyRotationRule(configRule) {
	configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"
} else = false {
	true
}
