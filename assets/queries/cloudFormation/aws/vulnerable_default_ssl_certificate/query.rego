package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	value := resource.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate
	isAttrTrue(value)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.CloudfrontDefaultCertificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'false' or not defined.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'true'.", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	attr := {"MinimumProtocolVersion", "SslSupportMethod"}
	attributes := attr[a]
	viewerCertificate := resource.Properties.DistributionConfig.ViewerCertificate

	hasCustomConfig(viewerCertificate)
	not common_lib.valid_key(viewerCertificate, attributes)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is defined", [name, attr[a]]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is not defined", [name, attr[a]]),
	}
}

isAttrTrue(value) {
	value == "true"
} else {
	value == true
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "IamCertificateId")
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "AcmCertificateArn")
}
