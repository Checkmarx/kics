package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault_secret[name]

	not resource.expiration_date

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault_secret[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'expiration_date' exists",
                "keyActualValue": 	"'expiration_date' is missing",
              }
}
