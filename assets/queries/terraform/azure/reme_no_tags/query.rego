package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.azurerm_cosmosdb_account[name]
  not resource.tags

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_cosmosdb_account[%s].tags", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'tags' is 'set'",
                "keyActualValue": 	"'tags' is 'undefined'"
              }
}