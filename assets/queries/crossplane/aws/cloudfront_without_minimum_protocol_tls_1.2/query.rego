package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	viewerCertificate := destribution_config.viewerCertificate
	not common_lib.is_recommended_tls(viewerCertificate.minimumProtocolVersion)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig.viewerCertificate.minimumProtocolVersion", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be TLSv1.2_x",
		"keyActualValue": sprintf("'viewerCertificate.minimumProtocolVersion' is %s", [viewerCertificate.minimumProtocolVersion]),
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], ["viewerCertificate", "minimumProtocolVersion"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config, "viewerCertificate")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'viewerCertificate' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	resource.spec.forProvider.distributionConfig.enabled == true
	viewerCertificate := resource.spec.forProvider.distributionConfig.viewerCertificate

	not common_lib.valid_key(viewerCertificate, "minimumProtocolVersion")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.distributionConfig.viewerCertificate", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'minimumProtocolVersion' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], ["viewerCertificate"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	viewerCertificate := destribution_config.viewerCertificate
	not common_lib.is_recommended_tls(viewerCertificate.minimumProtocolVersion)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig.viewerCertificate.minimumProtocolVersion", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be TLSv1.2_x",
		"keyActualValue": sprintf("'viewerCertificate.minimumProtocolVersion' is %s", [viewerCertificate.minimumProtocolVersion]),
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base","spec", "forProvider", "distributionConfig"], ["viewerCertificate", "minimumProtocolVersion"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config, "viewerCertificate")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'viewerCertificate' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base","spec", "forProvider", "distributionConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudfront.aws.crossplane.io")
	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig
	destribution_config.enabled == true
	viewerCertificate := destribution_config.viewerCertificate

	not common_lib.valid_key(viewerCertificate, "minimumProtocolVersion")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig.viewerCertificate", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'minimumProtocolVersion' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base","spec", "forProvider", "distributionConfig"], ["viewerCertificate"]),
	}
}
