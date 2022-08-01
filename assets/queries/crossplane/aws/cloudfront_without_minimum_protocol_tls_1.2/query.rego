package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	viewerCertificate := destribution_config.viewerCertificate
	not common_lib.is_recommended_tls(viewerCertificate.minimumProtocolVersion)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.distributionConfig.viewerCertificate.minimumProtocolVersion", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be TLSv1.2_x",
		"keyActualValue": sprintf("'viewerCertificate.minimumProtocolVersion' is %s", [viewerCertificate.minimumProtocolVersion]),
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig", "viewerCertificate", "minimumProtocolVersion"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config, "viewerCertificate")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.distributionConfig", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'viewerCertificate' is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	resource.spec.forProvider.distributionConfig.enabled == true
	viewerCertificate := resource.spec.forProvider.distributionConfig.viewerCertificate

	not common_lib.valid_key(viewerCertificate, "minimumProtocolVersion")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.distributionConfig.viewerCertificate", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'viewerCertificate.minimumProtocolVersion' should be defined and set to TLSv1.2_x",
		"keyActualValue": "'minimumProtocolVersion' is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig", "viewerCertificate"]),
	}
}
