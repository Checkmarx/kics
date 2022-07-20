package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig

	destribution_config.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.forProvider.distributionConfig.logging.enable", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be set to true",
		"keyActualValue": "Cloudfront logging is set to false",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], ["logging", "enabled"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig

	not common_lib.valid_key(destribution_config, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.forProvider.distributionConfig", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be defined and set to true",
		"keyActualValue": "Cloudfront logging is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig

	destribution_config.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig.logging.enable", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be set to true",
		"keyActualValue": "Cloudfront logging is set to false",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider", "distributionConfig"], ["logging", "enabled"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig

	not common_lib.valid_key(destribution_config, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be defined and set to true",
		"keyActualValue": "Cloudfront logging is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider", "distributionConfig"], []),
	}
}
