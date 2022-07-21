package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "SecurityGroup"
	ingressRules := resource.spec.forProvider.ingress

	startswith(resource.apiVersion, "ec2.aws.crossplane.io")
	ingressRule := ingressRules[j]
	ipRange := ingressRule.ipRanges[z]
	ipRange.cidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.forProvider.ingress.ipRanges.cidrIp={{%s}}", [ipRange.cidrIp]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress rule should not contain '0.0.0.0/0'",
		"keyActualValue": "ingress rule contains '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["ingress", j, "ipRanges", z, "cidrIp"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "ec2.aws.crossplane.io")
	resourceList[j].base.kind == "SecurityGroup"
	ingressRules := resourceList[j].base.spec.forProvider.ingress
	ingressRule := ingressRules[y]
	ipRange := ingressRule.ipRanges[z]
	ipRange.cidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.ingress.ipRanges.cidrIp={{%s}}", [resourceList[j].base.metadata.name, ipRange.cidrIp]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress rule should not contain '0.0.0.0/0'",
		"keyActualValue": "ingress rule contains '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["ingress", y, "ipRanges", z, "cidrIp"]),
	}
}
