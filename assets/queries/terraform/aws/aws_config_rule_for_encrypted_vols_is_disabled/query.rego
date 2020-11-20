package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  config := resource.aws_config_config_rule

  not checkSource(config,"ENCRYPTED_VOLUMES")

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "aws_config_config_rule[0]", #refer to the first rule
                "issueType":		"MissingAttrbute",
                "keyExpectedValue": "There is a 'aws_config_config_rule' resource has source id: 'ENCRYPTED_VOLUMES'",
                "keyActualValue": 	"No 'aws_config_config_rule' resource has source id: 'ENCRYPTED_VOLUMES'"
              }
}

checkSource(config_rules,expected_source) = true {
	source := config_rules[_].source
    source.source_identifier == expected_source
} else = false {
	true
}