package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[name]
    object.get(input.document[j].resource, "azurerm_monitor_diagnostic_setting", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'azurerm_monitor_diagnostic_setting' exists",
                "keyActualValue": 	"'azurerm_monitor_diagnostic_setting' is missing",
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[name]
    diagnosticResource := input.document[j].resource.azurerm_monitor_diagnostic_setting[_]

	not contains(diagnosticResource.target_resource_id, concat(".", ["azurerm_key_vault", name, "id"]))

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'azurerm_monitor_diagnostic_setting' exists",
                "keyActualValue": 	"'azurerm_monitor_diagnostic_setting' is missing",
              })
}