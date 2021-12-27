package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	
	not has_waf_associated(resource.Properties.StageName)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StageName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway Stage is associated with a Web Application Firewall",
		"keyActualValue": "API Gateway Stage is not associated with a Web Application Firewall",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "StageName"], []),
	}
}

has_waf_associated(stage) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::WAFv2::WebACLAssociation"

    contains(resource.Properties.ResourceArn, "arn:aws:apigateway:")
    associatedStage := split(resource.Properties.ResourceArn, "/")
    associatedStage[4] == stage
}
