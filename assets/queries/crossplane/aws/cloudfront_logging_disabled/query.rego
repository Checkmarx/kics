package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	destribution_config.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.distributionConfig.logging.enabled", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "CloudFront logging enabled attribute should be set to true",
		"keyActualValue": "CloudFront logging enabled attribute is set to false",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig", "logging", "enabled"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config.logging, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.distributionConfig.logging", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "CloudFront logging enabled attribute should be defined and set to true",
		"keyActualValue": "CloudFront enable is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig", "logging"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.distributionConfig", [common_lib.concat_path(path),resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "CloudFront logging enabled attribute should be defined and set to true",
		"keyActualValue": "CloudFront logging is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig"]),
	}
}
