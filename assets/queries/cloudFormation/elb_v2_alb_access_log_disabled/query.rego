package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
	prop := resource.Properties
	checkLbaAttr(prop)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerAttributes' has access_logs.s3.enabled with Value true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancerAttributes' doesn't have access_logs.s3.enabled with Value true", [name]),
	}
}

checkLbaAttr(prop) {
	object.get(prop, "LoadBalancerAttributes", "undefined") == "undefined"
}

checkLbaAttr(prop) {
	not object.get(prop, "LoadBalancerAttributes", "undefined") == "undefined"
	contains(prop.LoadBalancerAttributes, "access_logs.s3.enabled")
}

contains(arr, elem) {
	arr[i].Key == elem
	arr[i].Value == false
}
