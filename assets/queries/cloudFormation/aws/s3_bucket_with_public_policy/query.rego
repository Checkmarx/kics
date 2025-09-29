package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# Improved rule: Only flags S3 buckets that allow public policies 
# unless they are clearly intended for public use (websites, CDNs, etc.)
CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	Properties := resource.Properties
	not common_lib.valid_key(Properties, "PublicAccessBlockConfiguration") 
	
	# Only flag if this doesn't appear to be intentional public use
	not is_intentional_public_bucket(input.document[i].Resources, name, resource)

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
	
	# Only flag if this doesn't appear to be intentional public use
	not is_intentional_public_bucket(input.document[i].Resources, name, resource)

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
	
	# Only flag if this doesn't appear to be intentional public use
	not is_intentional_public_bucket(input.document[i].Resources, name, resource)

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

# Check if this appears to be an intentional public bucket (website, CDN, etc.)
is_intentional_public_bucket(resources, bucketName, bucket) {
	# Check bucket names for public use patterns
	has_public_bucket_name(bucketName)
} else {
	# Check for website configuration
	common_lib.valid_key(bucket.Properties, "WebsiteConfiguration")
} else {
	# Check for CloudFront distribution integration
	has_cloudfront_s3_integration(resources, bucketName)
} else {
	# Check for CORS configuration indicating intentional public access
	common_lib.valid_key(bucket.Properties, "CorsConfiguration")
} else {
	# Check for conditional public read policies
	has_conditional_public_access(resources, bucketName)
}

# Check if bucket name indicates public use
has_public_bucket_name(name) {
	publicIndicators := {"website", "static", "public", "assets", "cdn", "www", "web"}
	contains(lower(name), publicIndicators[_])
}

# Check if there's CloudFront distribution configured for this S3 bucket
has_cloudfront_s3_integration(resources, bucketName) {
	distribution := resources[_]
	distribution.Type == "AWS::CloudFront::Distribution"
	origin := distribution.Properties.DistributionConfig.Origins[_]
	contains(origin.DomainName, bucketName)
}

# Check for conditional public access policies (controlled public access)
has_conditional_public_access(resources, bucketName) {
	policy := resources[_]
	policy.Type == "AWS::S3::BucketPolicy"
	policy.Properties.Bucket == bucketName
	statement := policy.Properties.PolicyDocument.Statement[_]
	statement.Effect == "Allow"
	statement.Principal == "*"
	# Has conditions - indicates controlled access
	common_lib.valid_key(statement, "Condition")
}
