package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.azurerm_cosmosdb_account[name]
  not resource.tags

	result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("azurerm_cosmosdb_account[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].tags is defined'",
                "keyActualValue": sprintf("azurerm_cosmosdb_account[%s].tags is undefined'"
              }
}