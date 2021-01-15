package Cx

CxPolicy [ result ] {

    resourceBucket := input.document[indexBucket].Resources[nameBucket]
    resourceBucket.Type == "AWS::S3::Bucket"

    policyStatements := [policyStatement | 	resourcePolicy := input.document[indexBucket].Resources[_];
                                            resourcePolicy.Type == "AWS::S3::BucketPolicy";
                                            checkRef(resourcePolicy.Properties.Bucket, nameBucket);
                                            policyStatement := resourcePolicy.Properties.PolicyDocument.Statement[_]]

 	checkPolicyConfiguration(policyStatements)

	publicAccessBlockConfiguration := resourceBucket.Properties.PublicAccessBlockConfiguration
	publicAccessBlockConfiguration.RestrictPublicBuckets == false

	result := {
                "documentId": 		input.document[indexBucket].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration.RestrictPublicBuckets", [nameBucket]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'Resources.Properties.PublicAccessBlockConfiguration.RestrictPublicBuckets' is true",
                "keyActualValue": 	"'Resources.Properties.PublicAccessBlockConfiguration.RestrictPublicBuckets' is false"
                }
}

CxPolicy [ result ] {

  	resourceBucket := input.document[indexBucket].Resources[nameBucket]
  	resourceBucket.Type == "AWS::S3::Bucket"

	policyStatements := [policyStatement | 	resourcePolicy := input.document[indexBucket].Resources[_];
                                            resourcePolicy.Type == "AWS::S3::BucketPolicy";
                                            checkRef(resourcePolicy.Properties.Bucket, nameBucket);
                                            policyStatement := resourcePolicy.Properties.PolicyDocument.Statement[_]]

 	checkPolicyConfiguration(policyStatements)

	publicAccessBlockConfiguration := resourceBucket.Properties.PublicAccessBlockConfiguration
	publicAccessBlockConfiguration.IgnorePublicAcls == false

	result := {
                "documentId": 		input.document[indexBucket].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration.IgnorePublicAcls", [nameBucket]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'Resources.Properties.PublicAccessBlockConfiguration.IgnorePublicAcls' is true",
                "keyActualValue": 	"'Resources.Properties.PublicAccessBlockConfiguration.IgnorePublicAcls' is false"
                }
}


checkPolicyConfiguration(policyStatements) {
    some p
    policyStatements[p].Effect == "Allow"
    checkPolicy(policyStatements[p])
}
checkPolicy(policyProperty) {
 	policyProperty.Principal == "*"
}
checkPolicy(policyProperty) {
    policyProperty.Principal.AWS == "*"
}
checkPolicy(policyProperty) {
    policyProperty.Principal.AWS[_] == "*"
}

checkRef(obj, name) {
	obj.Ref == name
}
checkRef(obj, name) {
	obj == name
}

