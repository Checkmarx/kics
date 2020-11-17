package Cx

CxPolicy [ result ] {
  
  resource := input.document[i].resource.google_container_node_pool[name]
  object.get(resource, "management", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_container_node_pool[%s]", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google_container_node_pool.management is defined",
                "keyActualValue":   "google_container_node_pool.management is undefined"
              }
}

CxPolicy [ result ] {
  
  management := input.document[i].resource.google_container_node_pool[name].management
  object.get(management, "auto_upgrade", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_container_node_pool[%s].management", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "management.auto_upgrade is defined",
                "keyActualValue":   "management.auto_upgrade is undefined"
              }
}


CxPolicy [ result ] {
  
  management := input.document[i].resource.google_container_node_pool[name].management
  management.auto_upgrade == false
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_container_node_pool[%s].management.auto_upgrade", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "management.auto_upgrade is true",
                "keyActualValue":   "management.auto_upgrade is false"
              }
}

