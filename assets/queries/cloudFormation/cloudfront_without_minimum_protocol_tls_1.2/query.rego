package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties
	not common_lib.valid_key(properties.DistributionConfig, "ViewerCertificate")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate' is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties
	protocolVer := properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion
	not common_lib.inArray({"TLSv1.2_2018", "TLSv1.2_2019","TLSv1.2-2018", "TLSv1.2-2019"}, protocolVer)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' should be at least 1.2", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' lesser than 1.2", [name]),
	}
}
