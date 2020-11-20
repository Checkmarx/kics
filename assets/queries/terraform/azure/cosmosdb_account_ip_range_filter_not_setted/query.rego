package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.azurerm_cosmosdb_account[name]
	
	not resource.ip_range_filter
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_cosmosdb_account[%s].ip_range_filter", [name]),
                "issueType":		  "MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' is set", [name]),
                "keyActualValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' is undefined", [name])
              }
}

