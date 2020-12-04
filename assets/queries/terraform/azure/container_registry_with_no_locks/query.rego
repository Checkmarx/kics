package Cx
 


CxPolicy [  result ] {

 	resourceRegistry := input.document[i].resource.azurerm_container_registry[name]
 	resourceLock := input.document[i].resource.azurerm_management_lock[k]
  
    scopeSplitted := split(resourceLock.scope, ".")
    not re_match(scopeSplitted[1],  name)
   
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_container_registry[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_container_registry[%s] scope' contains azurerm_management_lock'", [name]),
                "keyActualValue": 	sprintf("'azurerm_container_registry[%s] scope' does not contain azurerm_management_lock'", [name])
              }
}

