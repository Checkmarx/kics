package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	distributionConfig := resource.Properties.DistributionConfig
	not cf_lib.isCloudFormationFalse(distributionConfig.Enabled)
	not common_lib.valid_key(distributionConfig, "Logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	distributionConfig := resource.Properties.DistributionConfig
	not cf_lib.isCloudFormationFalse(distributionConfig.Enabled)

	bucketCorrect := resource.Properties.DistributionConfig.Logging.Bucket
	endswith(bucketCorrect, ".s3.amazonaws.com") == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DistributionConfig.Logging.Bucket", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket should have the domain '.s3.amazonaws.com'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging.Bucket does not have the correct domain", [name]),
	}
}
