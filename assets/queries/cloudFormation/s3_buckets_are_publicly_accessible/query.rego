package Cx

CxPolicy [ result ] {
 	resourcePolicy := input.document[indexPolicy].Resources[namePolicy]
	policyProperties := [policyProperties | resourcePolicy.Type == "AWS::IAM::Policy"; policyProperties = resourcePolicy.Properties.PolicyDocument]
	policyStatements := policyProperties[_].Statement[index]
    
  resourceBucket := input.document[indexBucket].Resources[nameBucket]
  bucketProperties := [bucketProperties | resourceBucket.Type == "AWS::S3::Bucket"; bucketProperties = resourceBucket.Properties]

 	checkPolicyConfiguration(policyStatements)
  checkPublicAccessBlockConfiguration(bucketProperties)
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [nameBucket]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Resources.Properties.Statement.Principal' should be 'Allow' with 'Resources.Properties.Statement.Principal' or 'Resources.Properties.Statement.Principal.AWS' different from '*'",
                "keyActualValue": 	"'Resources.Properties.Statement.Principal' is 'Allow' with 'Resources.Properties.Statement.Principal' or 'Resources.Properties.Statement.Principal.AWS' equals to '*'",
              }
}

checkPublicAccessBlockConfiguration(bucketProperties) = true {
	checkAccess(bucketProperties[_].PublicAccessBlockConfiguration)
}
checkAccess(property){
	property != null
	property.RestrictPublicBuckets != true
}
checkAccess(property){
	property != null
    property.IgnorePublicAcls != true
}

checkPolicyConfiguration(policyProperties) {
    policyProperties.Effect == "Allow"
    checkPolicy(policyProperties)
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



