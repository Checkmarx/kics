package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	isLoadBalancer(resource)
	not internalALB(resource)
	not associatedWAF(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.Type=AWS::WAFRegional::WebACLAssociation.ResourceArn.Ref=%s' is defined", [name]),
		"keyActualValue": sprintf("'Resources.Type=AWS::WAFRegional::WebACLAssociation.ResourceArn.Ref=%s' is undefined", [name]),
	}
}

isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
}

isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
}

internalALB(resource) {
	scheme := resource.Properties.Scheme
	scheme == "internal"
}

associatedWAF(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn.Ref == target_alb
}

associatedWAF(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn == target_alb
}
