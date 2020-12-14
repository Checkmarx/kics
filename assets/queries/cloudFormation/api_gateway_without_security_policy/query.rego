package Cx

CxPolicy [ result ] {
   document := input.document
   resource = document[i].Resources[name]
   resource.Type == "AWS::ApiGateway::DomainName"
   
   properties := resource.Properties
   exists_security_policy := object.get(properties, "SecurityPolicy", "undefined") != "undefined"
   not exists_security_policy
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.SecurityPolicy", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.SecurityPolicy is not defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.SecurityPolicy is defined", [name])
              }
} 


CxPolicy [ result ] {
   document := input.document
   resource = document[i].Resources[name]
   resource.Type == "AWS::ApiGateway::DomainName"
   
   tls := "TLS_1_2"
   resource.Properties.SecurityPolicy != tls
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.SecurityPolicy", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.SecurityPolicy is %s", [name, tls]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.SecurityPolicy should be %s", [name, tls])
              }
} 