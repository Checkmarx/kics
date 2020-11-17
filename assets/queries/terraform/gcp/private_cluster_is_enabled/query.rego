package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  object.get(resource, "private_cluster_config", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s]", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'private_cluster_config' is defined",
                "keyActualValue": 	"Attribute 'private_cluster_config' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  object.get(resource.private_cluster_config, "enable_private_endpoint", "undefined") == "undefined"
  object.get(resource.private_cluster_config, "enable_private_nodes", "undefined") != "undefined"
  

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is defined",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_endpoint' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  object.get(resource.private_cluster_config, "enable_private_endpoint", "undefined") != "undefined"
  object.get(resource.private_cluster_config, "enable_private_nodes", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_nodes' is defined",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_nodes' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  object.get(resource.private_cluster_config, "enable_private_endpoint", "undefined") == "undefined"
  object.get(resource.private_cluster_config, "enable_private_nodes", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is defined and Attribute 'private_cluster_config.enable_private_nodes' is defined",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_endpoint' is undefined and Attribute 'private_cluster_config.enable_private_nodes' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.private_cluster_config.enable_private_endpoint == false
  resource.private_cluster_config.enable_private_nodes

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is true",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_endpoint' is false"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.private_cluster_config.enable_private_endpoint
  resource.private_cluster_config.enable_private_nodes == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_nodes' is true",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_nodes' is false"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.private_cluster_config.enable_private_endpoint == false
  resource.private_cluster_config.enable_private_nodes == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is true and Attribute 'private_cluster_config.enable_private_nodes' is true",
                "keyActualValue": 	"Attribute 'private_cluster_config.enable_private_endpoint' is false and Attribute 'private_cluster_config.enable_private_nodes' is false"
              }
}