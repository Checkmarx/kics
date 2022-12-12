package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources
    configRules := cf_lib.getResourcesByType(resources, "AWS::Config::ConfigRule")

    count(configRules) > 0
    not hasEncryptedVolsRule(configRules)

    firstRule := resources[name]
    firstRule.Type == "AWS::Config::ConfigRule"

	result := {
		"documentId": input.document[i].id,
        "resourceType": firstRule.Type,
		"resourceName": cf_lib.get_resource_name(firstRule, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a ConfigRule for encrypted volumes.",
		"keyActualValue": "There isn't a ConfigRule for encrypted volumes."
	}
}

hasEncryptedVolsRule(configRules) {
    configRule := configRules[_]
    source := configRule.Properties.Source
    source_id := source.SourceIdentifier
    source_id == "ENCRYPTED_VOLUMES"
}
