package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	resource.kind == "SecurityGroup"
	ingressRules := resource.spec.forProvider.ingress

	startswith(resource.apiVersion, "ec2.aws.crossplane.io")
	ingressRule := ingressRules[j]
	ipRange := ingressRule.ipRanges[z]
	ipRange.cidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.ingress.ipRanges.cidrIp={{%s}}", [cp_lib.getPath(path), resource.metadata.name, ipRange.cidrIp]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress rule should not contain '0.0.0.0/0'",
		"keyActualValue": "ingress rule contains '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "ingress", j, "ipRanges", z, "cidrIp"]),
	}
}
