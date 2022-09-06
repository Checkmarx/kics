package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties
	not cf_lib.isCloudFormationFalse(properties.DistributionConfig.Enabled)
	not common_lib.valid_key(properties.DistributionConfig, "ViewerCertificate")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate' should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate' is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "DistributionConfig"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties
	protocolVer := properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion
	not cf_lib.isCloudFormationFalse(properties.DistributionConfig.Enabled)
	not common_lib.is_recommended_tls(protocolVer)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' should be TLSv1.2_x", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.MinimumProtocolVersion' is %s", [name, protocolVer]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "DistributionConfig", "ViewerCertificate", "MinimumProtocolVersion"]),
	}
}
