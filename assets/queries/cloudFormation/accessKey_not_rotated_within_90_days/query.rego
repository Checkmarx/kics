package Cx

CxPolicy [ result ] {
	document := input.document[i]
  not hasAccessKeyRotationRule(document)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    "Resources",
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Resources has a ConfigRule defining rotation period on AccessKeys.",
                "keyActualValue": 	"Resources doesn't have a ConfigRule defining rotation period on AccessKeys."
              }
}

CxPolicy [ result ] {
	document := input.document[i]
  configRule := document.Resources[name]
  configRule.Type == "AWS::Config::ConfigRule"
  configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"

  object.get(configRule.Properties,"InputParameters","undefined") == "undefined"
	
  result := {
                "documentId": 		document.id,
                "searchKey": 	    "Resources.%s.Properties",
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.InputParameters is defined and contains 'maxAccessKeyAge' key.",[name]),
                "keyActualValue": 	sprintf("Resources.%s.InputParameters is undefined.",[name])
              }
}

CxPolicy [ result ] {
	document := input.document[i]
  configRule := document.Resources[name]
  configRule.Type == "AWS::Config::ConfigRule"
  configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"

  maxDays := configRule.Properties.InputParameters.maxAccessKeyAge

  to_number(maxDays) > 90
	
  result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("Resources.%s.Properties.InputParameters.maxAccessKeyAge",[name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.InputParameters.maxAccessKeyAge is less or equal to 90 (days)",[name]),
                "keyActualValue": 	sprintf("Resources.%s.InputParameters.maxAccessKeyAge is more than 90 (days).",[name])
              }
}

hasAccessKeyRotationRule(document) {
    configRule := document.Resources[_]
    configRule.Type == "AWS::Config::ConfigRule"
    configRule.Properties.Source.SourceIdentifier == "ACCESS_KEYS_ROTATED"
} else = false
