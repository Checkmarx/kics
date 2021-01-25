package Cx

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucketName := resource

	not bucketHasPolicyWithValidSslVerification(bucketName, resources)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [bucketName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s bucket should have a policy that enforces SSL", [bucketName]),
		"keyActualValue": sprintf("Resources.%s bucket doesn't have a policy or has a policy that doesn't enforce SSL", [bucketName]),
	}
}

bucketHasPolicyWithValidSslVerification(bucketName, resources) {
	some resource
	resources[resource].Type == "AWS::S3::BucketPolicy"

	policy = resources[resource2]

	policy.Properties.Bucket == bucketName
	count({stmt | isValidSslPolicyStatement(policy.Properties.PolicyDocument.Statement[stmt])}) > 0
}

isUnsafeAction("s3:*") = true

isUnsafeAction("s3:PutObject") = true

equalsFalse("false") = true

equalsFalse(false) = true

isValidSslPolicyStatement(stmt) {
	stmt.Effect == "Deny"
	isUnsafeAction(stmt.Action)
	equalsFalse(stmt.Condition.Bool["aws:SecureTransport"])
}
