package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.aws_config_rule"].publicly_accessible)
	configRules := [t | tasks[_]["community.aws.aws_config_rule"]; t := tasks[x]]

	not checkSource(configRules, "ENCRYPTED_VOLUMES")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_config_rule}}.source.identifier", [configRules[0].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'",
		"keyActualValue": "There is no aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'",
	}
}

checkSource(configRules, expected_source) {
	source := configRules[_]["community.aws.aws_config_rule"].source
	upper(source.identifier) == expected_source
}
