package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  encryption := resource.azurerm_managed_disk[name]
  object.get(encryption, "encryption_settings", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_managed_disk[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings is defined ", [name]),
                "keyActualValue": 	sprintf("azurerm_managed_disk[%s].encryption_settings is undefined", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource
  encryption := resource.azurerm_managed_disk[name]
  encryption.encryption_settings.enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is true ", [name]),
                "keyActualValue": 	sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is false", [name])
              }
}

