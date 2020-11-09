package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_security_center_subscription_pricing[name]

	tier := lower(resource.tier)
	tier == "free"
    
    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_security_center_subscription_pricing[%s].tier", [name]),
                "issueType":		"WrongValue",
                "keyExpectedValue": sprintf("'azurerm_security_center_subscription_pricing.%s.tier' should be 'Standard'",[name]),
                "keyActualValue": 	sprintf("'azurerm_security_center_subscription_pricing.%s.tier' is 'Free'",[name]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
