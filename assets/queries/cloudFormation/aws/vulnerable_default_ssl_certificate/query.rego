package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	value := resource.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate
	cf_lib.isCloudFormationTrue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig.CloudfrontDefaultCertificate", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate should be set to 'false' or not defined.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'true'.", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
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
		"searchKey": sprintf("%s%s.Properties.DistributionConfig.ViewerCertificate", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s should be defined", [name, attr[a]]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is not defined", [name, attr[a]]),
	}
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "IamCertificateId")
}

hasCustomConfig(viewerCertificate) {
	common_lib.valid_key(viewerCertificate, "AcmCertificateArn")
}
