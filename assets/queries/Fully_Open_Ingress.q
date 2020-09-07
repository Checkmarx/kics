package Cx

#CxPragma "$.resource ? (@.aws_security_group_rule != null || @.aws_security_group != null"
#Security groups allow ingress from 0.0.0.0:0
#https://www.terraform.io/docs/providers/aws/r/security_group.html
#https://www.terraform.io/docs/providers/aws/r/security_group_rule.html


result [ getMetadata({"id" : input.All[i].CxId, "data" : [rule], "search": ["0.0.0.0/0", "cidr_blocks"]}) ] {
	rule := input.All[i].resource.aws_security_group_rule[name]
    rule.type == "ingress"
    rule.from_port
    rule.to_port
    contains(rule.cidr_blocks[_], "0.0.0.0/0")     
}


result [ getMetadata({"id" : input.All[i].CxId, "data" : [ingrs], "search": ["0.0.0.0/0", "cidr_blocks"]}) ] {
	ingrs := input.All[i].resource.aws_security_group[name].ingress
    ingrs.from_port
    ingrs.to_port    
    contains(ingrs.cidr_blocks[_], "0.0.0.0/0")     
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Fully open Ingress",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
