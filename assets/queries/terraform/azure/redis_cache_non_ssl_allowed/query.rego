package Cx

CxPolicy [ result ] {
  cache := input.document[i].resource.azurerm_redis_cache[name]
  cache.enable_non_ssl_port == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_redis_cache[%s].enable_non_ssl_port", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue":  sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is false or undefined (false as default)", [name]),
                "keyActualValue": 	 sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is true", [name])
              }
}