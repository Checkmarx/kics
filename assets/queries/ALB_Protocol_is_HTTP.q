package Cx

#CxPragma "$.resource ? (@.aws_alb_listener != null || @.aws_lb_listener != null)"

#AWS Application Load Ballancer (alb) should not listen on HTTP
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource[lb[idx]][name]], "search": concat("+", [lb[idx], name]) }) ] {
	lb := {"aws_alb_listener", "aws_lb_listener"}
	upper(input.All[i].resource[lb[idx]][name].protocol) = "HTTP"
    not input.All[i].resource[lb[idx]][name].default_action.redirect.protocol
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource[lb[idx]][name]], "search": [concat("+", [lb[idx], name]), "default_action", "redirect", "protocol"]}) ] {
	lb := {"aws_alb_listener", "aws_lb_listener"}
	upper(input.All[i].resource[lb[idx]][name].protocol) = "HTTP"
    upper(input.All[i].resource[lb[idx]][name].default_action.redirect.protocol) != "HTTPS"
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "ALB protocol is HTTP",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
