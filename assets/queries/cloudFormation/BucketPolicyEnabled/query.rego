package Cx

CxPolicy [ result ] {
 	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
    
    containsPolicy(name)
	object.get(resource.Properties, "LoggingConfiguration", "not found") == "not found"
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties' has property 'LoggingConfiguration'", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties' doesn't have property 'LoggingConfiguration'", [name])
              }
}

containsPolicy(name) = true {

	some resource
    	input.document[_].Resources[resource].Type == "AWS::S3::BucketPolicy"
        input.document[_].Resources[resource].Properties.Bucket.Ref == name
        input.document[_].Resources[resource].Properties.PolicyDocument.Statement[0].Principal.Service == "cloudtrail.amazonaws.com"  
        
}