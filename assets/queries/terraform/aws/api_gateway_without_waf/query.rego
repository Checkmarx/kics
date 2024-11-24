package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	apiGateway := document.resource.aws_api_gateway_stage[name]

	not has_waf_associated(name)

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(apiGateway, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway Stage should be associated with a Web Application Firewall",
		"keyActualValue": "API Gateway Stage is not associated with a Web Application Firewall",
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name], []),
	}
}

has_waf_associated(apiGatewayName) {
	targetResources := {"aws_wafregional_web_acl_association", "aws_wafv2_web_acl_association"}

	some waf in targetResources

	resource := document.resource[waf][_]

	associatedResource := split(resource.resource_arn, ".")

	associatedResource[0] == "${aws_api_gateway_stage"
	associatedResource[1] == apiGatewayName
}
