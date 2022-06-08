package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources

	resources[resourceName].Type == "AWS::S3::Bucket"

	bucketName := resourceName

	not bucketHasPolicy(bucketName, resources)

	result := {
		"documentId": document.id,
		"resourceType": resources[resourceName].Type,
		"resourceName": cf_lib.get_resource_name(resources[resourceName], resourceName),
		"searchKey": sprintf("Resources.%s", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s bucket has a policy that enforces SSL", [bucketName]),
		"keyActualValue": sprintf("Resources.%s bucket doesn't have a policy", [bucketName]),
		"searchLine": common_lib.build_search_line(["Resources", bucketName], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources

	resources[resourceName].Type == "AWS::S3::Bucket"

	bucketName := resourceName

	bucketHasPolicy(bucketName, resources)
	not bucketHasPolicyWithValidSslVerification(bucketName, resources)

	result := {
		"documentId": document.id,
		"resourceType": resources[resourceName].Type,
		"resourceName": cf_lib.get_resource_name(resources[resourceName], resourceName),
		"searchKey": sprintf("Resources.%s", [bucketName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s bucket has a policy that enforces SSL", [bucketName]),
		"keyActualValue": sprintf("Resources.%s bucket doesn't have a policy or has a policy that doesn't enforce SSL", [bucketName]),
		"searchLine": common_lib.build_search_line(["Resources", bucketName], []),
	}
}

bucketHasPolicy(bucketName, resources) {
	resources[_].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[_]) == bucketName
}

bucketHasPolicyWithValidSslVerification(bucketName, resources) {
	resources[_].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[_]) == bucketName

	isValidSslPolicyStatement(resources[_].Properties.PolicyDocument.Statement)
}

isUnsafeAction("s3:*") = true

isUnsafeAction("s3:PutObject") = true

equalsFalse("false") = true

equalsFalse(false) = true

isValidSslPolicyStatement(stmt) {
	is_array(stmt)
    st := stmt[s]
	st.Effect == "Deny"
	isUnsafeAction(st.Action)
	equalsFalse(st.Condition.Bool["aws:SecureTransport"])
} else {
	is_object(stmt)
    stmt.Effect == "Deny"
	isUnsafeAction(stmt.Action)
	equalsFalse(stmt.Condition.Bool["aws:SecureTransport"])
}
