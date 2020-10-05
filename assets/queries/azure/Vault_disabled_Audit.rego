package Cx

SupportedResources = "$.resource.azurerm_key_vault"

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[name]
    object.get(input.document[j].resource, "azurerm_monitor_diagnostic_setting", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "Diagnostic exists",
                "keyActualValue": 	"null",
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
                "keyExpectedValue": "Diagnostic exists",
                "keyActualValue": 	"null",
              })
}