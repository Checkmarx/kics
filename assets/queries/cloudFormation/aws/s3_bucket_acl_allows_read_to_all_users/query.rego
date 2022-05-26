package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	properties := resource.Properties
	resource.Type == "AWS::S3::Bucket"
	properties.AccessControl == "PublicRead"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AccessControl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 bucket should not have a public readable ACL",
		"keyActualValue": sprintf("S3 bucket '%s' has ACL set to '%s'", [name, properties.AccessControl]),
	}
}
