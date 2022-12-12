package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	route := input.document[i].resource.aws_route53_record[name]
	count(route.records) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_route53_record",
		"resourceName": tf_lib.get_resource_name(route, name),
		"searchKey": sprintf("aws_route53_record[%s].records", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_route53_record.records should be defined",
		"keyActualValue": "aws_route53_record.records is undefined",
	}
}
