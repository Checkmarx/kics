package Cx

CxPolicy[result] {
	lb := {"aws_alb", "aws_lb"}
	resource := input.document[i].resource[lb[idx]][name]
	not is_internal_alb(resource)
	not associated_waf(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s]", [lb[idx], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s]' is not 'internal' and has a 'aws_wafregional_web_acl_association' associated", [lb[idx], name]),
		"keyActualValue": sprintf("'%s[%s]' is not 'internal' and does not have a 'aws_wafregional_web_acl_association' associated", [lb[idx], name]),
	}
}

is_internal_alb(resource) {
	resource.internal == true
}

associated_waf(name) {
	waf := input.document[_].resource.aws_wafregional_web_acl_association[waf_name]
	attribute := waf.resource_arn
	attribute_split := split(attribute, ".")
	options := {"${aws_alb", "${aws_lb"}
	attribute_split[0] == options[x]
	attribute_split[1] == name
}
