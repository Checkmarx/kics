package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	distributionConfig := resource.Properties.DistributionConfig

	cf_lib.isCloudFormationFalse(distributionConfig.Enabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig.Enabled", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled should be 'true'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled is configured as 'false'", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties.DistributionConfig

	not common_lib.valid_key(properties, "Origins")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig should contain an 'Origins' object", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig does not contain an 'Origins' object configured", [name]),
	}
}

