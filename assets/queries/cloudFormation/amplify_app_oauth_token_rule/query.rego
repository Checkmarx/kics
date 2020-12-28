package Cx


CxPolicy [ result ]  {

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::Amplify::App"

  properties := resource.Properties
  paramName  := properties.OauthToken

  defaultToken := document.Parameters[paramName].Default

  regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`,defaultToken)
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
  paramName  := properties.OauthToken
  count(paramName)>=50
  defaultToken := paramName
  object.get(document, "Parameters" , "undefined") != "undefined"
  object.get(document.Parameters, paramName , "undefined") == "undefined"

  regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`,defaultToken)
  not hasSecretManager(defaultToken, document.Resources)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.BasicAuthConfig.Password", [key]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must not be in plain text string",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.BasicAuthConfig.Password must be defined as a parameter or have a secret manager referenced",[key])
              }
}


CxPolicy [  result ]  {

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::Amplify::App"

  properties := resource.Properties
  paramName  := properties.OauthToken
  object.get(document, "Parameters" , "undefined") == "undefined"
  count(paramName)>=50
  defaultToken := paramName


  regex.match(`[A-Za-z0-9\-\._~\+\/]+=*`,defaultToken)
  not hasSecretManager(defaultToken, document.Resources)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.BasicAuthConfig.Password", [key]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.BasicAuthConfig.Password must not be in plain text string",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.BasicAuthConfig.Password must be defined as a parameter or have a secret manager referenced",[key])
              }
}

hasSecretManager(str, document) {
	selectedSecret :=  strings.replace_n({"${":"","}":""}, regex.find_n(`\${\w+}`,str,1)[0])
  document[selectedSecret].Type == "AWS::SecretsManager::Secret"
}