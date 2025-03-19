package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	Properties := resource.Properties
	not common_lib.valid_key(Properties, "PublicAccessBlockConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'PublicAccessBlockConfiguration' should be defined",
		"keyActualValue": "'PublicAccessBlockConfiguration' is not defined",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	PublicAccessBlockConfiguration := resource.Properties.PublicAccessBlockConfiguration
	not common_lib.valid_key(PublicAccessBlockConfiguration, "RestrictPublicBuckets")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'RestrictPublicBuckets' should be defined and set to true in the 'PublicAccessBlockConfiguration'",
		"keyActualValue": "'RestrictPublicBuckets' is not defined in the 'PublicAccessBlockConfiguration'",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PublicAccessBlockConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	PublicAccessBlockConfiguration := resource.Properties.PublicAccessBlockConfiguration
	PublicAccessBlockConfiguration.RestrictPublicBuckets == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration.RestrictPublicBuckets", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'RestrictPublicBuckets' should be set to true",
		"keyActualValue": "'RestrictPublicBuckets' is set to false",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PublicAccessBlockConfiguration", "RestrictPublicBuckets"], []),
	}
}
