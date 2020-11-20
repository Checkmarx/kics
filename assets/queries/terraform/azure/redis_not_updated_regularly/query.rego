package Cx

CxPolicy [ result ] {
    redis_cache := input.document[i].resource.azurerm_redis_cache[name]
    
    object.get(redis_cache, "patch_schedule", "undefined") == "undefined"
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_redis_cache[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' is defined", [name]),
                "keyActualValue": 	sprintf("'azurerm_redis_cache[%s].patch_schedule' is not defined", [name]),
              }
}