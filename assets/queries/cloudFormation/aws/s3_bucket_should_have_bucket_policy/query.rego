package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"

	not has_bucket_policy(resource, name)

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' should be associated with an 'AWS::S3::BucketPolicy'", [name, name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' is not associated with an 'AWS::S3::BucketPolicy'", [name, name]),
		"searchLine": common_lib.build_search_line(path, [name]),
	}
}

match(bucketResource, resourceName, bucketAssociated) {
	bucketAssociated == resourceName
} else {
	bucketAssociated == bucketResource.Properties.BucketName
}

has_bucket_policy(bucketResource, resourceName) {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucketAssociated := cf_lib.getBucketName(resource)

	match(bucketResource, resourceName, bucketAssociated)
}
