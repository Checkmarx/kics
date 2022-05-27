package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {
	"aws_cloudfront_distribution",
	"aws_lb",
	"aws_globalaccelerator_accelerator",
	"aws_eip",
	"aws_route53_zone"
}


CxPolicy[result] {
	target := input.document[i].resource[resources[idx]][name]

	not has_shield_advanced(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[idx],
		"resourceName": tf_lib.get_resource_name(target, name),
		"searchKey": sprintf("%s[%s]", [resources[idx], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s has shield advanced associated", [resources[idx]]),
		"keyActualValue": sprintf("%s does not have shield advanced associated", [resources[idx]]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name], []),
	}
}

has_shield_advanced(name) {
	shield := input.document[_].resource.aws_shield_protection[_]
	matches(shield, name)
}

matches(shield, name) {
	split(shield.resource_arn,".")[1] == name
} else {
	target := split(shield.resource_arn,"/")[1]
	split(target,".")[1] == name
}
