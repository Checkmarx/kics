package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	value := resource.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate
	cf_lib.isCloudFormationTrue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.CloudfrontDefaultCertificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate should be set to 'false' or not defined.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'true'.", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DistributionConfig", "ViewerCertificate"], ["CloudfrontDefaultCertificate"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	attr := {"MinimumProtocolVersion", "SslSupportMethod"}
	attributes := attr[a]
	viewerCertificate := resource.Properties.DistributionConfig.ViewerCertificate

	hasCustomConfig(viewerCertificate)
	not common_lib.valid_key(viewerCertificate, attributes)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate", [name]),
		"searchValue": attributes,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s should be defined", [name, attr[a]]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is not defined", [name, attr[a]]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DistributionConfig", "ViewerCertificate"], []),
	}
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "IamCertificateId")
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "AcmCertificateArn")
}
