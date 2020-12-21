package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  metadata := resource.Metadata[mdata]
  mdata == "AWS::CloudFormation::Authentication"
  creds := metadata[accessCreds]
  creds.type == "S3"
  object.get(creds, "accessKeyId", "undefined") != "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Metadata.%s.%s.accessKeyId",[name,mdata,accessCreds]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.accessKeyId is undefined",[name,mdata,accessCreds]),
                "keyActualValue": 	sprintf("Resources.%s.Metadata.%s.%s.accessKeyId is defined",[name,mdata,accessCreds]),
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  metadata := resource.Metadata[mdata]
  mdata == "AWS::CloudFormation::Authentication"
  creds := metadata[accessCreds]
  creds.type == "S3"
  object.get(creds, "secretKey", "undefined") != "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Metadata.%s.%s.secretKey",[name,mdata,accessCreds]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.secretKey is undefined",[name,mdata,accessCreds]),
                "keyActualValue": 	sprintf("Resources.%s.Metadata.%s.%s.secretKey is defined",[name,mdata,accessCreds]),
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  metadata := resource.Metadata[mdata]
  mdata == "AWS::CloudFormation::Authentication"
  creds := metadata[accessCreds]
  creds.type == "basic"
  object.get(creds, "password", "undefined") != "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Metadata.%s.%s.password",[name,mdata,accessCreds]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.password is undefined",[name,mdata,accessCreds]),
                "keyActualValue": 	sprintf("Resources.%s.Metadata.%s.%s.password is defined",[name,mdata,accessCreds]),
              }
}

