package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.google_compute_project_metadata[name].metadata
  #enable := object.get(resource, "enable-oslogin", "undefined") == "undefined"
  resource["enable-oslogin"] == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s.metadata", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "enable-oslogin is true",
                "keyActualValue": 	"enable-oslogin is false"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_compute_project_metadata[name].metadata
  #resource["enable-oslogin"] == undefined
  #enable := object.get(resource, "enable-oslogin", "undefined") == "undefined"
  not resource["enable-oslogin"]
  not resource["enable-oslogin"] == false
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s.metadata", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "enable-oslogin is true",
                "keyActualValue": 	"enable-oslogin is missing"
              }
}