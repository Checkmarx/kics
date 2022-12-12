package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	properties := resource.Properties
	resource.Type == "AWS::S3::Bucket"
	properties.AccessControl == "AuthenticatedRead"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AccessControl", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 bucket ACL shouldn't allow read operations from any authenticated user",
		"keyActualValue": sprintf("S3 bucket named '%s' has ACL set to '%s'", [object.get(resource.Properties, "BucketName", "undefined"), properties.AccessControl]),
	}
}
