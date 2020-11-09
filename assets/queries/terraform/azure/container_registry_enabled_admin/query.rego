package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_container_registry[name]

	resource.admin_enabled == true

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_container_registry[%s].admin_enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'admin_enabled' equal 'false'",
                "keyActualValue": 	"'admin_enabled' equal 'true'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}