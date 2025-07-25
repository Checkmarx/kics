package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources

	resources[resourceName].Type == "AWS::S3::Bucket"

	not bucketHasPolicy(resources[resourceName], resourceName, resources)

	result := {
		"documentId": document.id,
		"resourceType": resources[resourceName].Type,
		"resourceName": cf_lib.get_resource_name(resources[resourceName], resourceName),
		"searchKey": sprintf("Resources.%s", [resourceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s bucket has a policy that enforces SSL", [resourceName]),
		"keyActualValue": sprintf("Resources.%s bucket doesn't have a policy", [resourceName]),
		"searchLine": common_lib.build_search_line(["Resources", resourceName], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources

	resources[resourceName].Type == "AWS::S3::Bucket"

	bucketHasPolicy(resources[resourceName], resourceName, resources)
	not bucketHasPolicyWithValidSslVerification(resources[resourceName], resourceName, resources)

	result := {
		"documentId": document.id,
		"resourceType": resources[resourceName].Type,
		"resourceName": cf_lib.get_resource_name(resources[resourceName], resourceName),
		"searchKey": sprintf("Resources.%s", [resourceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s bucket has a policy that enforces SSL", [resourceName]),
		"keyActualValue": sprintf("Resources.%s bucket doesn't have a policy or has a policy that doesn't enforce SSL", [resourceName]),
		"searchLine": common_lib.build_search_line(["Resources", resourceName], []),
	}
}

bucketHasPolicy(bucket, bucketLogicalName, resources) {
	resources[a].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[a]) == bucket.Properties.BucketName
} else {
	resources[a].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[a]) == bucketLogicalName
}

bucketHasPolicyWithValidSslVerification(bucket, bucketLogicalName, resources) {
	resources[a].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[a]) == bucket.Properties.BucketName

	isValidSslPolicyStatement(resources[a].Properties.PolicyDocument.Statement)
} else {
	resources[a].Type == "AWS::S3::BucketPolicy"
	cf_lib.getBucketName(resources[a]) == bucketLogicalName

	isValidSslPolicyStatement(resources[a].Properties.PolicyDocument.Statement)
}

isUnsafeAction("s3:*") = true

isUnsafeAction("s3:PutObject") = true


isValidSslPolicyStatement(stmt) {
	is_array(stmt)
	st := stmt[s]
	st.Effect == "Deny"
	isUnsafeAction(st.Action)
	cf_lib.isCloudFormationFalse(st.Condition.Bool["aws:SecureTransport"])
} else {
	is_array(stmt)
	st := stmt[s]
	st.Effect == "Deny"
	is_array(st.Action)
	action := st.Action[i]
	isUnsafeAction(action)
	cf_lib.isCloudFormationFalse(st.Condition.Bool["aws:SecureTransport"])
} 
else {
	is_object(stmt)
	stmt.Effect == "Deny"
	isUnsafeAction(stmt.Action)
	cf_lib.isCloudFormationFalse(stmt.Condition.Bool["aws:SecureTransport"])
}
else {
	is_array(stmt)
	st := stmt[s]
	st.Effect == "Allow"
	isUnsafeAction(st.Action)
	not cf_lib.isCloudFormationFalse(st.Condition.Bool["aws:SecureTransport"])
} else {
	is_array(stmt)
	st := stmt[s]
	st.Effect == "Allow"
	is_array(st.Action)
	action := st.Action[i]
	isUnsafeAction(action)
	not cf_lib.isCloudFormationFalse(st.Condition.Bool["aws:SecureTransport"])
} 
else {
	is_object(stmt)
	stmt.Effect == "Allow"
	isUnsafeAction(stmt.Action)
	not cf_lib.isCloudFormationFalse(stmt.Condition.Bool["aws:SecureTransport"])
}
