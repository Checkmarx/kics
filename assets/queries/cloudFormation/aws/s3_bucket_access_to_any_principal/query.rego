package Cx

import future.keywords.in
import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resourceBucket := input.document[indexBucket].Resources[nameBucket]
	resourceBucket.Type == "AWS::S3::Bucket"

	policyStatements := [policyStatement |
		resourcePolicy := input.document[indexBucket].Resources[_]
		resourcePolicy.Type == "AWS::S3::BucketPolicy"
		check_ref(resourcePolicy.Properties.Bucket, resourceBucket, nameBucket)
		raw_policy := resourcePolicy.Properties.PolicyDocument
		statements := common_lib.get_statement(common_lib.get_policy(raw_policy))
        clean_statements := handle_if_statements(statements)
		policyStatement := clean_statements[_]
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

handle_if_statements(raw_statements) = cleaned_statements {
    nested := [handle_if_statement(s) | s := raw_statements[_]]
    flattened := [x | some sublist in nested; x := sublist[_]]
    cleaned_statements := flattened
}

handle_if_statement(raw_policy) = policies {
    raw_policy.playbooks

    policies := [item |
        item := raw_policy.playbooks[_]
        is_object(item)
    ]

} else = policies {
    policies := [raw_policy]  
}

check_ref(obj, bucketResource , logicName) {
	obj.Ref == logicName
} else {
	obj == logicName
} else {
	obj == bucketResource.Properties.BucketName
}
