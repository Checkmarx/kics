package Cx

CxPolicy [ result ] {
  nodePool := input.document[i].resource.google_container_node_pool[name]
  nodePool.management.auto_repair == false
 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_node_pool[%s].management.auto_repair", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair is true", [name]),
                "keyActualValue": sprintf("google_container_node_pool[%s].management.auto_repair is false", [name])
              }
}

CxPolicy [ result ] {
  nodePool := input.document[i].resource.google_container_node_pool[name]
  object.get(nodePool, "management", "undefined") == "undefined"
 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_node_pool[%s].management", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair is defined", [name]),
                "keyActualValue": sprintf("google_container_node_pool[%s].management.auto_repair is undefined", [name])
              }
}