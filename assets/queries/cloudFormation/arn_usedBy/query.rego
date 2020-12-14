package Cx

CxPolicy [ result ] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::CertificateManager::Certificate"
   
    object.get(resource,"InUseBy","undefined") == "undefined"
    
    result := {
        "documentId":         input.document[i].id,
        "searchKey":         sprintf("Resources.%s", [name]),
        "issueType":        "IncorrectValue",  
        "keyExpectedValue": sprintf("Resources.%s.InUseBy should exist",[name]),
        "keyActualValue":   sprintf("Resources.%s.InUseBy does not exist",[name])
    }
}

CxPolicy [ result ] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::CertificateManager::Certificate"
   
    object.get(resource,"InUseBy","undefined") != "undefined"
    
    useBy := resource.InUseBy

    count(useBy) == 0
    
    result := {
        "documentId":         input.document[i].id,
        "searchKey":         sprintf("Resources.%s.InUseBy", [name]),
        "issueType":        "IncorrectValue",  
        "keyExpectedValue": sprintf("Resources.%s.InUseBy should not be empty",[name]),
        "keyActualValue":   sprintf("Resources.%s.InUseBy is empty",[name])
    }
}

CxPolicy [ result ] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::CertificateManager::Certificate"
   
    object.get(resource,"InUseBy","undefined") != "undefined"
    
    useBy := resource.InUseBy

    some j 
	isARN(useBy[j]) == false
    
    result := {
        "documentId":         input.document[i].id,
        "searchKey":         sprintf("Resources.%s.InUseBy", [name]),
        "issueType":        "IncorrectValue",  
        "keyExpectedValue": sprintf("Resources.%s.InUseBy should only contain ARN",[name]),
        "keyActualValue":   sprintf("Resources.%s.InUseBy does not contain only ARN",[name])
    }
}

isARN(string) = true{
	regex.match("arn:[(0-9A-Za-z_)+=/,.@-]+:[(0-9A-Za-z_)+=/,.@-]+:[(0-9A-Za-z_)+=/,.@-]*:[0-9]+:[(0-9A-Za-z_)+=,.@-]+(/[(0-9A-Za-z_)+=,.@-]+)*", string)
}
isARN(string) = false{
	not regex.match("arn:[(0-9A-Za-z_)+=/,.@-]+:[(0-9A-Za-z_)+=/,.@-]+:[(0-9A-Za-z_)+=/,.@-]*:[0-9]+:[(0-9A-Za-z_)+=,.@-]+(/[(0-9A-Za-z_)+=,.@-]+)*", string)
}