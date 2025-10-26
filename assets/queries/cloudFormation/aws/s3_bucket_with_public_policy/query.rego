package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# IMPROVED VERSION: Reduces False Positives by considering legitimate public policy use cases
CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	Properties := resource.Properties
	not common_lib.valid_key(Properties, "PublicAccessBlockConfiguration") 
	
	# Only flag if this bucket doesn't appear to be for legitimate public use
	not is_legitimate_cf_public_bucket(resource, name, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'PublicAccessBlockConfiguration' should be defined for non-public buckets", [name]),
		"keyActualValue": sprintf("'PublicAccessBlockConfiguration' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	PublicAccessBlockConfiguration := resource.Properties.PublicAccessBlockConfiguration
	not common_lib.valid_key(PublicAccessBlockConfiguration, "BlockPublicPolicy") 
	
	# Only flag if this bucket doesn't appear to be for legitimate public use
	not is_legitimate_cf_public_bucket(resource, name, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'BlockPublicPolicy' should be defined and set to true for non-public buckets", [name]),
		"keyActualValue": sprintf("'BlockPublicPolicy' is not defined in the 'PublicAccessBlockConfiguration'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PublicAccessBlockConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	PublicAccessBlockConfiguration := resource.Properties.PublicAccessBlockConfiguration
	cf_lib.isCloudFormationFalse(PublicAccessBlockConfiguration.BlockPublicPolicy)
	
	# Only flag if this bucket doesn't appear to be for legitimate public use
	not is_legitimate_cf_public_bucket(resource, name, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration.BlockPublicPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'BlockPublicPolicy' should be set to true for non-public buckets", [name]),
		"keyActualValue": sprintf("'BlockPublicPolicy' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PublicAccessBlockConfiguration", "BlockPublicPolicy"], []),
	}
}

# Helper function: Check if CloudFormation bucket is for legitimate public use
is_legitimate_cf_public_bucket(resource, bucket_name, document) {
	# Check bucket name patterns that indicate public use
	public_bucket_patterns := {
		"website", "static", "public", "assets", "cdn", "content", 
		"media", "images", "js", "css", "frontend", "web", "hosting",
		"cloudfront", "distribution", "logs", "backup"
	}
	
	bucket_name_lower := lower(bucket_name)
	contains(bucket_name_lower, public_bucket_patterns[_])
}

is_legitimate_cf_public_bucket(resource, bucket_name, document) {
	# Check if bucket has website configuration
	common_lib.valid_key(resource.Properties, "WebsiteConfiguration")
}

is_legitimate_cf_public_bucket(resource, bucket_name, document) {
	# Check if bucket is used with CloudFront
	cloudfront := document.Resources[_]
	cloudfront.Type == "AWS::CloudFront::Distribution"
	origin := cloudfront.Properties.DistributionConfig.Origins[_]
	contains(origin.DomainName, bucket_name)
}

is_legitimate_cf_public_bucket(resource, bucket_name, document) {
	# Check if bucket has public read policy that's intentional (with conditions)
	bucket_policy := document.Resources[_]
	bucket_policy.Type == "AWS::S3::BucketPolicy"
	bucket_policy.Properties.Bucket == bucket_name
	
	# Policy has conditions (indicates controlled public access)
	statement := bucket_policy.Properties.PolicyDocument.Statement[_]
	common_lib.valid_key(statement, "Condition")
}
