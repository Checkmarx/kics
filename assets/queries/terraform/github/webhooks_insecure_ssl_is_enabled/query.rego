package Cx

CxPolicy [ result ] {
  webhook := input.document[i].resource.github_organization_webhook[name]
  webhook.configuration.insecure_ssl == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("github_organization_webhook[%s].configuration.insecure_ssl", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("github_organization_webhook[%s].configuration.insecure_ssl is false", [name]),
                "keyActualValue": 	sprintf("github_organization_webhook[%s].configuration.insecure_ssl is true", [name])
              }
}