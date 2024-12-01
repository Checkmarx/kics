package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

waf_resources := [
	"aws_wafv2_web_acl_association",
	"aws_wafregional_web_acl_association",
]

CxPolicy[result] {
	lb := {"aws_alb", "aws_lb"}
	some document in input.document
	resource := document.resource[lb[idx]][name]
	not is_internal_alb(resource)
	count({x | x := associated_waf(name)}) == 0

	result := {
		"documentId": document.id,
		"resourceType": lb[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [lb[idx], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s]' should not be 'internal' and has a 'aws_wafregional_web_acl_association' associated", [lb[idx], name]),
		"keyActualValue": sprintf("'%s[%s]' is not 'internal' and does not have a 'aws_wafregional_web_acl_association' associated", [lb[idx], name]),
	}
}

is_internal_alb(resource) {
	resource.internal == true
}

associated_waf(name) {
	some document in input.document
	waf := document.resource[waf_resources[_]][_]
	attribute := waf.resource_arn
	attribute_split := split(attribute, ".")
	options := {"${aws_alb", "${aws_lb"}
	attribute_split[0] == options[x]
	attribute_split[1] == name
}
