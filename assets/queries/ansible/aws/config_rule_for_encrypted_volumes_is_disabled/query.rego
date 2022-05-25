package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.aws_config_rule", "aws_config_rule"}

CxPolicy[result] {
	tasks := ansLib.tasks[id]
	configRules := [t | ansLib.checkState(tasks[x][modules[_]]); t := tasks[x]]

	not checkSource(configRules, "ENCRYPTED_VOLUMES")

	configRules[0][modules[m]]

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": configRules[0].name,
		"searchKey": sprintf("name={{%s}}", [configRules[0].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'",
		"keyActualValue": "There is no aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'",
	}
}

checkSource(configRules, expected_source) {
	source := configRules[_][modules[_]].source
	upper(source.identifier) == expected_source
}
