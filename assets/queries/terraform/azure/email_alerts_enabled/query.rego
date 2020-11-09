package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_security_center_contact[name]

	not resource.alert_notifications
    
    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_security_center_contact[%s].alert_notifications", [name]),
                "issueType":		"WrongValue",
                "keyExpectedValue": sprintf("'azurerm_security_center_contact.%s.alert_notifications' is true",[name]),
                "keyActualValue": 	sprintf("'azurerm_security_center_contact.%s.alert_notifications' is false",[name]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
