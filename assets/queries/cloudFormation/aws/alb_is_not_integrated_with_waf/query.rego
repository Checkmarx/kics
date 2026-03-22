package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cf_lib.isLoadBalancer(resource)
	not internal_alb(resource)
	not associated_waf(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' should not have an 'internal' scheme and should have a 'WebACLAssociation' associated", [name]),
		"keyActualValue": sprintf("'Resources.%s' does not have an 'internal' scheme and a 'WebACLAssociation' associated", [name]),
	}
}

internal_alb(resource) {
	scheme := resource.Properties.Scheme
	scheme == "internal"
}

waf_association_types := {"AWS::WAFRegional::WebACLAssociation", "AWS::WAFv2::WebACLAssociation"}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	waf_association_types[resource.Type]
	resource.Properties.ResourceArn.Ref == target_alb
}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	waf_association_types[resource.Type]
	resource.Properties.ResourceArn == target_alb
}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	waf_association_types[resource.Type]
	resource.Properties.ResourceArn["Fn::GetAtt"][0] == target_alb
}

associated_waf(target_alb) {
	resource := input.document[_].Resources[_]
	waf_association_types[resource.Type]
	startswith(resource.Properties.ResourceArn, sprintf("%s.", [target_alb]))
}
