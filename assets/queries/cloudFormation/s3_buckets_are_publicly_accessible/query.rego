package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  
  policyProperties := [policyProperties | resource.Type == "AWS::IAM::Policy"; policyProperties = resource.Properties.PolicyDocument]
  policyStatements := policyProperties[_].Statement[index]
  
  checkPolicyConfiguration(policyStatements)

  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PolicyDocument", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Resources.Properties.Statement.Principal' should be 'Allow' with 'Resources.Properties.Statement.Principal' or 'Resources.Properties.Statement.Principal.AWS' different from '*'",
                "keyActualValue": 	"'Resources.Properties.Statement.Principal' is 'Allow' with 'Resources.Properties.Statement.Principal' or 'Resources.Properties.Statement.Principal.AWS' equals to '*'",
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  
  bucketProperties := [bucketProperties | resource.Type == "AWS::S3::Bucket"; bucketProperties = resource.Properties]
  
  checkPublicAccessBlockConfiguration(bucketProperties)

  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Resources.Properties.PublicAccessBlockConfiguration' is setted and configuration has value true",
                "keyActualValue": 	"'Resources.Properties.PublicAccessBlockConfiguration' is not setted or configuration has value false "
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



