package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	distributionConfig := resource.Properties.DistributionConfig
	object.get(distributionConfig, "Logging", "notfound") == "notfound"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	distributionConfig := resource.Properties.DistributionConfig
	object.get(distributionConfig, "Logging", "notfound") != "notfound"

	bucketCorrect := resource.Properties.DistributionConfig.Logging.Bucket
	endswith(bucketCorrect, ".s3.amazonaws.com") == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket should have the domain '.s3.amazonaws.com'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket does not have the correct domain", [name]),
	}
}
