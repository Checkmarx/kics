package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_postgresql_configuration[var0]
	name := lower(resource.name)
	value := upper(resource.value)

    name == "log_checkpoints"
    value != "ON"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_configuration[%s].value", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_configuration.%s.value' should be 'ON'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_configuration.%s.value' is 'OFF'", [var0]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}