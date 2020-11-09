package Cx

CxPolicy [ result ] {
	rule := input.file[i].resource.aws_security_group_rule[name]
    rule.type == "ingress"
    rule.from_port
    rule.to_port
    contains(rule.cidr_blocks[idx], "0.0.0.0/0")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'rule.cidr_blocks' not equal '0.0.0.0/0'",
                "keyActualValue": 	"One of 'rule.cidr_blocks' is equal '0.0.0.0/0'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            rule.cidr_blocks[idx]
              }
}

CxPolicy [ result ] {
	ingrs := input.file[i].resource.aws_security_group[name].ingress
    ingrs.from_port
    ingrs.to_port
    contains(ingrs.cidr_blocks[idx], "0.0.0.0/0")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
                "keyActualValue": 	"One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            ingrs.cidr_blocks[idx]
              }
}

