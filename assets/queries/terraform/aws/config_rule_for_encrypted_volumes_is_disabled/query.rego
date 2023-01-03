package Cx

CxPolicy[result] {
	resource := input.document[i].resource
	config := resource.aws_config_config_rule

	not checkSource(config, "ENCRYPTED_VOLUMES")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_config_config_rule",
		"resourceName": "unknown",
		"searchKey": "aws_config_config_rule", #refer to the first rule
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a 'aws_config_config_rule' resource with source id: 'ENCRYPTED_VOLUMES'",
		"keyActualValue": "No 'aws_config_config_rule' resource has source id: 'ENCRYPTED_VOLUMES'",
	}
}

checkSource(config_rules, expected_source) {
	source := config_rules[_].source
	source.source_identifier == expected_source
} else = false {
	true
}
