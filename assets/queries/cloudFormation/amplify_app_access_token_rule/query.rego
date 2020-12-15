package Cx


CxPolicy [ result ]  { 

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::Amplify::App"

  properties := resource.Properties
  paramName  := properties.AccessToken
  defaultToken := document.Parameters[paramName].Default
  count(defaultToken) > 50
  regex.match(`[A-Za-z0-9-._~+\/]+=*`,defaultToken) 
  not hasSecretManager(defaultToken, document.Resources)
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Parameters.%s.Default", [paramName]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Parameters.%s.Default is defined",[paramName]),
                "keyActualValue": 	sprintf("Parameters.%s.Default shouldn't be defined",[paramName])
              }
}



CxPolicy [  result ]  { 

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::Amplify::App"

  properties := resource.Properties
  paramName  := properties.AccessToken
  object.get(document, "Parameters", "undefined") == "undefined" 

  defaultToken := paramName
  count(defaultToken) > 50
  regex.match(`[A-Za-z0-9-._~+\/]+=*`,defaultToken) 
  not hasSecretManager(defaultToken, document.Resources)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.AccessToken", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.Properties.AccessToken must not be in plain text string",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.AccessToken must be defined as a parameter or have a secret manager referenced",[key])
              }
}





hasSecretManager(str, document) = true {
	selectedSecret :=  strings.replace_n({"${":"","}":""}, regex.find_n(`\${\w+}`,str,1)[0])
    document[selectedSecret].Type == "AWS::SecretsManager::Secret"
    result := true
}else = false { true }


