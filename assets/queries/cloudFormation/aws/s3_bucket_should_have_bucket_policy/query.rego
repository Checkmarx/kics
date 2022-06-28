package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	not has_bucket_policy(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' is the same as an 'AWS::S3::BucketPolicy' Bucket", [name, name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BucketName' or 'Resources.[%s]' is not the same as an 'AWS::S3::BucketPolicy' Bucket", [name, name]),
		"searchLine": common_lib.build_search_line(["Resources", name], []),
	}
}


match(bucketResource, resourceName, bucketAssociated) {
	bucketAssociated == resourceName
} else {
	bucketAssociated == bucketResource.Properties.BucketName
}


has_bucket_policy(bucketResource, resourceName) {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	bucketAssociated := cf_lib.getBucketName(resource)

	match(bucketResource, resourceName, bucketAssociated)

}
