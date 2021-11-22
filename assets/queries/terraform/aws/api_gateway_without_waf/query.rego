package Cx

import data.generic.common as common_lib

CxPolicy[result] {

    apiGateway := input.document[i].resource.aws_api_gateway_stage[name]

    not has_waf_associated(name)

    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway Stage is associated with a Web Application Firewall",
		"keyActualValue": "API Gateway Stage is not associated with a Web Application Firewall",
        "searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name], []),
	}
}

has_waf_associated(apiGatewayName) {
    resource := input.document[_].resource.aws_wafregional_web_acl_association[_]
   
    associatedResource := split(resource.resource_arn, ".")
   
    associatedResource[0] == "${aws_api_gateway_stage"
    associatedResource[1] == apiGatewayName
}
