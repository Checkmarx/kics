package Cx

CxPolicy [ result ] {
  project := input.document[i].resource.google_project[name]
  project.auto_create_network == false
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_project[%s].auto_create_network", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("google_project[name].auto_create_network is false", [name]),
				        "keyActualValue": sprintf("google_project[name].auto_create_network is true", [name]),
              }
}

CxPolicy [ result ] {
  project := input.document[i].resource.google_project[name]
  object.get(project, "auto_create_network", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_project[%s].auto_create_network", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("google_project[%s].auto_create_network is false", [name]),
                "keyActualValue": 	sprintf("google_project[%s].auto_create_network is undefined", [name]),
              }
} 