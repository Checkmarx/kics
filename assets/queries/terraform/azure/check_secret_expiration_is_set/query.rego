package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_key_vault_secret[name]

	not resource.expiration_date

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault_secret[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'expiration_date' exists",
                "keyActualValue": 	"'expiration_date' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
              }
}
