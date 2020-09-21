package Cx

SupportedResources = "$.resource ? (@.aws_security_group_rule != null || @.aws_security_group != null"

CxPolicy [ result ] {
	rule := input.document[i].resource.aws_security_group_rule[name]
    rule.type == "ingress"
    rule.from_port
    rule.to_port
    contains(rule.cidr_blocks[_], "0.0.0.0/0")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	rule.cidr_blocks[key]
              })
}

CxPolicy [ result ] {
	ingrs := input.document[i].resource.aws_security_group[name].ingress
    ingrs.from_port
    ingrs.to_port
    contains(ingrs.cidr_blocks[_], "0.0.0.0/0")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	ingrs.cidr_blocks[key]
              })
}

