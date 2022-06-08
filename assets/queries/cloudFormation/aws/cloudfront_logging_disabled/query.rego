package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	distributionConfig := resource.Properties.DistributionConfig
	not common_lib.valid_key(distributionConfig, "Logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
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

	bucketCorrect := resource.Properties.DistributionConfig.Logging.Bucket
	endswith(bucketCorrect, ".s3.amazonaws.com") == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket should have the domain '.s3.amazonaws.com'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket does not have the correct domain", [name]),
	}
}
