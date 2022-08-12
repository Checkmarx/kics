package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"
	not checkPublicAccessBlockConfiguration(resource.Properties.PublicAccessBlockConfiguration)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.PublicAccessBlockConfiguration", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PublicAccessBlockConfiguration' should be set and configuration attributes should have value true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PublicAccessBlockConfiguration' is not set or any configuration attribute has value false", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"

	checkWebsiteConfiguration(resource.Properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' and 'Resources.%s.Properties.AcessControl' should be undefined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' or 'Resources.%s.Properties.AccessControl' are defined", [name]),
	}
}

checkPublicAccessBlockConfiguration(properties) {
	properties.BlockPublicAcls == true
	properties.BlockPublicPolicy == true
	properties.IgnorePublicAcls == true
	properties.RestrictPublicBuckets == true
}

checkWebsiteConfiguration(properties) {
	common_lib.valid_key(properties, "WebsiteConfiguration") # ensure that is defined and not null
}

checkWebsiteConfiguration(properties) {
	common_lib.valid_key(properties, "AccessControl") # ensure that is defined and not null
	properties.AccessControl != "Private"
}
