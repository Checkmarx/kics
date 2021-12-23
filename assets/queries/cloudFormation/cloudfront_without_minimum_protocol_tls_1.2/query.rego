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
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DistributionConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties
	protocolVer := properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion
	not common_lib.is_recommended_tls(protocolVer)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' is TLSv1.2_x", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' is %s", [name, protocolVer]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DistributionConfig", "ViewerCertificate", "MinimumProtocolVersion"], []),
	}
}
