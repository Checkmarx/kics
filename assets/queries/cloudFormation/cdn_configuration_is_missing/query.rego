package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	distributionConfig := resource.Properties.DistributionConfig

	isFalse(distributionConfig.Enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled is 'true'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled is configured as 'false'", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	properties := resource.Properties.DistributionConfig

	object.get(properties, "Origins", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig contains an 'Origins' object", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig does not contain an 'Origins' object configured", [name]),
	}
}

isFalse(value) {
	value == false
} else {
	value == "false"
}
