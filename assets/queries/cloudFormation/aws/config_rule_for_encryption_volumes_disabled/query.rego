package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resources := doc.Resources
	configRules := cf_lib.getResourcesByType(resources, "AWS::Config::ConfigRule")

	count(configRules) > 0
	not hasEncryptedVolsRule(configRules)

	firstRule := resources[name]
	firstRule.Type == "AWS::Config::ConfigRule"

	result := {
		"documentId": doc.id,
		"resourceType": firstRule.Type,
		"resourceName": cf_lib.get_resource_name(firstRule, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a ConfigRule for encrypted volumes.",
		"keyActualValue": "There isn't a ConfigRule for encrypted volumes.",
	}
}

hasEncryptedVolsRule(configRules) {
	some configRule in configRules
	source := configRule.Properties.Source
	source_id := source.SourceIdentifier
	source_id == "ENCRYPTED_VOLUMES"
}
