package Cx


CxPolicy [result ]  {

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::DocDB::DBCluster"

  properties := resource.Properties
  paramName  := properties.MasterUserPassword
  defaultToken := document.Parameters[paramName].Default

   regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`,defaultToken)
   not hasSecretManager(defaultToken, document.Resources)

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Parameters.%s.Default", [paramName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Parameters.%s.Default is defined",[paramName]),
                "keyActualValue": 	sprintf("Parameters.%s.Default shouldn't be defined",[paramName])
              }
}

CxPolicy [result]  {

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::DocDB::DBCluster"

  properties := resource.Properties
  paramName  := properties.MasterUserPassword
  object.get(document, "Parameters" , "undefined") != "undefined"
  object.get(document.Parameters, paramName , "undefined") == "undefined"

  defaultToken := paramName

  regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`,defaultToken)
  not hasSecretManager(defaultToken, document.Resources)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.MasterUserPassword", [key]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.MasterUserPassword must not be in plain text string",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.MasterUserPassword must be defined as a parameter or have a secret manager referenced",[key])
              }

}


CxPolicy [result]  {

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::DocDB::DBCluster"

  properties := resource.Properties
  paramName  := properties.MasterUserPassword
  object.get(document, "Parameters", "undefined") == "undefined"

  defaultToken := paramName

  regex.match(`[A-Za-z\d@$!%*"#"?&]{8,}`,defaultToken)
  not hasSecretManager(defaultToken, document.Resources)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.MasterUserPassword", [key]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.MasterUserPassword must not be in plain text string",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.MasterUserPassword must be defined as a parameter or have a secret manager referenced",[key])
              }

}


hasSecretManager(str, document) {
	selectedSecret :=  strings.replace_n({"${":"","}":""}, regex.find_n(`\${\w+}`,str,1)[0])
  document[selectedSecret].Type == "AWS::SecretsManager::Secret"
}


