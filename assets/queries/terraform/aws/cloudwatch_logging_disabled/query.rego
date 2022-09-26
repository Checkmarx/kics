package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	route := resource.aws_route53_zone[name]
	not resource.aws_route53_query_log[name]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_route53_zone",
		"resourceName": tf_lib.get_resource_name(route, name),
		"searchKey": sprintf("aws_route53_zone[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_route53_query_log' should be set for respective 'aws_route53_zone'",
		"keyActualValue": "'aws_route53_query_log' is undefined",
	}
}

# TODO review this query...
# all resources should have different names
CxPolicy[result] {
	route := input.document[i].resource.aws_route53_query_log[name]
	log_group := route.cloudwatch_log_group_arn

	not regex.match(name, log_group)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_route53_query_log",
		"resourceName": tf_lib.get_resource_name(route, name),
		"searchKey": sprintf("aws_route53_query_log[%s].cloudwatch_log_group_arn", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_route53_query_log' log group refers to the query log",
		"keyActualValue": "'aws_route53_query_log' log group does not match with the log name",
	}
}
