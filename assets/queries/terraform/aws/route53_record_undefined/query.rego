package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	route := document.resource.aws_route53_record[name]
	count(route.records) == 0

	result := {
		"documentId": document.id,
		"resourceType": "aws_route53_record",
		"resourceName": tf_lib.get_resource_name(route, name),
		"searchKey": sprintf("aws_route53_record[%s].records", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_route53_record.records should be defined",
		"keyActualValue": "aws_route53_record.records is undefined",
	}
}
