package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	resourceBucket := input.document[indexBucket].Resources[nameBucket]
	resourceBucket.Type == "AWS::S3::Bucket"

	policyStatements := [policyStatement |
		some resourcePolicy in input.document[indexBucket].Resources
		resourcePolicy.Type == "AWS::S3::BucketPolicy"
		check_ref(resourcePolicy.Properties.Bucket, resourceBucket, nameBucket)
		policy := resourcePolicy.Properties.PolicyDocument
		st := common_lib.get_statement(common_lib.get_policy(policy))
		some policyStatement in st
		common_lib.is_allow_effect(policyStatement)
	]

	common_lib.any_principal(policyStatements[_])

	result := {
		"documentId": input.document[indexBucket].id,
		"resourceType": resourceBucket.Type,
		"resourceName": cf_lib.get_resource_name(resourceBucket, nameBucket),
		"searchKey": sprintf("Resources.%s", [nameBucket]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "associated Bucket Policy should not allow access to any principal",
		"keyActualValue": "associated Bucket Policy allows access to any principal",
		"searchLine": common_lib.build_search_line(["Resource", nameBucket], []),
	}
}

check_ref(obj, bucketResource, logicName) {
	obj.Ref == logicName
} else {
	obj == logicName
} else {
	obj == bucketResource.Properties.BucketName
}
