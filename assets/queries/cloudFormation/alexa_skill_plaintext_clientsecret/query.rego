package Cx

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "Alexa::ASK::Skill"	
    is_string(resource.Properties.AuthenticationConfiguration.ClientSecret) == false
    
result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.AuthenticationConfiguration.ClientSecret",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.ClientSecret' should be a string", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.ClientSecret' is not a string", [name]),
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "Alexa::ASK::Skill"
    clientSecret := resource.Properties.AuthenticationConfiguration.ClientSecret
    not startswith(clientSecret, "{{resolve:secretsmanager:")
    not startswith(clientSecret, "{{resolve:ssm-secure:")
     
result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.AuthenticationConfiguration.ClientSecret",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.ClientSecret' should start with with '{{resolve:secretsmanager:' or started with '{{resolve:ssm-secure:'", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.ClientSecret' does not started '{{resolve:secretsmanager:' or doesn't start with '{{resolve:ssm-secure:'", [name]),
              }
}


