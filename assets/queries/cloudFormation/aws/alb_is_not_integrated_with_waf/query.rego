package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cloudFormationLib.isLoadBalancer(resource)
	not internal_alb(resource)
	not associated_waf(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' does not have an 'internal' scheme and has a 'WebACLAssociation' associated", [name]),
		"keyActualValue": sprintf("'Resources.%s' does not have an 'internal' scheme and a 'WebACLAssociation' associated", [name]),
	}
}

internal_alb(resource) {
	scheme := resource.Properties.Scheme
	scheme == "internal"
}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn.Ref == target_alb
}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn == target_alb
}
