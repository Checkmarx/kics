package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	distributionConfig := resource.Properties.DistributionConfig

	not common_lib.valid_key(distributionConfig, "WebACLId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.WebACLId is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.WebACLId is undefined", [name]),
	}
}
