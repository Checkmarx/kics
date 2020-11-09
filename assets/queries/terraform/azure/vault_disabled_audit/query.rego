package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_key_vault[name]
    object.get(input.file[j].resource, "azurerm_monitor_diagnostic_setting", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'azurerm_monitor_diagnostic_setting' exists",
                "keyActualValue": 	"'azurerm_monitor_diagnostic_setting' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_key_vault[name]
    diagnosticResource := input.file[j].resource.azurerm_monitor_diagnostic_setting[_]

	not contains(diagnosticResource.target_resource_id, concat(".", ["azurerm_key_vault", name, "id"]))

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'azurerm_monitor_diagnostic_setting' exists",
                "keyActualValue": 	"'azurerm_monitor_diagnostic_setting' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
              }
}