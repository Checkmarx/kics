package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled==true

	destribution_config.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig.logging.enabled", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be set to true",
		"keyActualValue": "Cloudfront logging enabled attribute is set to false",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], ["logging", "enabled"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled==true

	not common_lib.valid_key(destribution_config.logging, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig.logging", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be defined and set to true",
		"keyActualValue": "Cloudfront enable is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], ["logging"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled==true

	not common_lib.valid_key(destribution_config, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig", [resource.metadata.name]),
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

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"	
	
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled==true
	destribution_config.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig.logging.enabled", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be set to true",
		"keyActualValue": "Cloudfront logging enabled attribute is set to false",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider", "distributionConfig"], ["logging", "enabled"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled==true

	not common_lib.valid_key(destribution_config.logging, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig.logging", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cloudfront logging enabled attribute should be defined and set to true",
		"keyActualValue": "Cloudfront enabled is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider", "distributionConfig"], ["logging"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled==true

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
