package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	properties := resource.Properties
	resource.Type == "AWS::S3::Bucket"
	properties.AccessControl == "PublicReadWrite"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.AccessControl", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 bucket should not have a public readable and writeble ACL",
		"keyActualValue": sprintf("S3 bucket named '%s' has ACL set to '%s'", [object.get(resource.Properties, "BucketName", "undefined"), properties.AccessControl]),
	}
}
