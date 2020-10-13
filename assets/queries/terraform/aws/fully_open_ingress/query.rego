package Cx

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
                "keyExpectedValue": "One of 'rule.cidr_blocks' not equal '0.0.0.0/0'",
                "keyActualValue": 	"One of 'rule.cidr_blocks' is equal '0.0.0.0/0'"
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
                "keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
                "keyActualValue": 	"One of 'ingress.cidr_blocks' equal '0.0.0.0/0'"
              })
}

