package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	route := input.document[i].resource.aws_route53_record[name]
	count(route.records) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_route53_record[%s].records", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_route53_record.records is defined",
		"keyActualValue": "aws_route53_record.records is undefined",
	}
}
