package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	path := check_allow_all(resource.default_cache_behavior)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy should be 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	path = check_allow_all(resource.ordered_cache_behavior)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.{{%s}}.viewer_protocol_policy", [name, path[_].path_pattern]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy should be 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'", [name]),
	}
}

check_allow_all(resource) = path {
	is_array(resource)
	path := {x | resource[n].viewer_protocol_policy == "allow-all"; x := resource[n]}
} else = path {
	not is_array(resource)
	resource.viewer_protocol_policy == "allow-all"
	path := {x | x := resource}
}
