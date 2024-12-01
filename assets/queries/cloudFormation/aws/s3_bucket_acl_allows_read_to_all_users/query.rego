package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	properties := resource.Properties
	resource.Type == "AWS::S3::Bucket"
	properties.AccessControl == "PublicRead"

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AccessControl", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 bucket should not have a public readable ACL",
		"keyActualValue": sprintf("S3 bucket '%s' has ACL set to '%s'", [name, properties.AccessControl]),
	}
}
