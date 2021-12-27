package Cx

import data.generic.cloudformation as cfLib

CxPolicy[result] {
	resources := input.document[i].Resources
    configRules := cfLib.getResourcesByType(resources, "AWS::Config::ConfigRule")

    count(configRules) > 0
    not hasEncryptedVolsRule(configRules)

    firstRule := resources[name]
    firstRule.Type == "AWS::Config::ConfigRule"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There is a ConfigRule for encrypted volumes.",
		"keyActualValue": "There isn't a ConfigRule for encrypted volumes."
	}
}

hasEncryptedVolsRule(configRules) {
    configRule := configRules[_]
    source := configRule.Properties.Source
    source_id := source.SourceIdentifier
    source_id == "ENCRYPTED_VOLUMES"
}
