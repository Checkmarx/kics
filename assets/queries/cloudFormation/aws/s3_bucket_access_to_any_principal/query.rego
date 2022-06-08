package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resourceBucket := input.document[indexBucket].Resources[nameBucket]
	resourceBucket.Type == "AWS::S3::Bucket"

	policyStatements := [policyStatement |
		resourcePolicy := input.document[indexBucket].Resources[_]
		resourcePolicy.Type == "AWS::S3::BucketPolicy"
		check_ref(resourcePolicy.Properties.Bucket, nameBucket)
		policy := resourcePolicy.Properties.PolicyDocument
		st := common_lib.get_statement(common_lib.get_policy(policy))
		policyStatement := st[_]
		common_lib.is_allow_effect(policyStatement)
	]

	common_lib.any_principal(policyStatements[_])

	publicAccessBlockConfiguration := resourceBucket.Properties.PublicAccessBlockConfiguration

	targets := {"RestrictPublicBuckets", "IgnorePublicAcls"}
	publicAccessBlockConfiguration[targets[t]] == false

	result := {
		"documentId": input.document[indexBucket].id,
		"resourceType": resourceBucket.Type,
		"resourceName": cf_lib.get_resource_name(resourceBucket, nameBucket),
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration.%s", [nameBucket, targets[t]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.Properties.PublicAccessBlockConfiguration.%s' is set to true", [targets[t]]),
		"keyActualValue": sprintf("'Resources.Properties.PublicAccessBlockConfiguration.%s' is set to false", [targets[t]]),
		"searchLine": common_lib.build_search_line(["Resource", nameBucket, "Properties", "PublicAccessBlockConfiguration", targets[t]], []),
	}
}

check_ref(obj, name) {
	obj.Ref == name
} else {
	obj == name
}
