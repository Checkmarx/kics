package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  not resource.master_auth

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s]", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'master_auth' is defined",
                "keyActualValue": 	"Attribute 'master_auth' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  not resource.master_auth.username
  resource.master_auth.password

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": "Attribute 'username' of 'master_auth' is defined and empty",
                "keyActualValue": 	"Attribute 'username' of 'master_auth' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  resource.master_auth.username
  not resource.master_auth.password

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": "Attribute 'password' of 'master_auth' is defined and empty",
                "keyActualValue": 	"Attribute 'password' of 'master_auth' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  not resource.master_auth.username
  not resource.master_auth.password

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attributes 'username' and 'password' are defined and empty",
                "keyActualValue": 	"Attributes 'username' and 'password' are undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  count(resource.master_auth.username) > 0
  count(resource.master_auth.password) == 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "Attribute 'username' of 'master_auth' is defined and empty",
                "keyActualValue": 	"Attribute 'username' of 'master_auth' is not empty"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  count(resource.master_auth.username) == 0
  count(resource.master_auth.password) > 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "Attribute 'password' of 'master_auth' is defined and empty",
                "keyActualValue": 	"Attribute 'password' of 'master_auth' is not empty"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.master_auth
  count(resource.master_auth.username) > 0
  count(resource.master_auth.password) > 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].master_auth", [primary]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attributes 'username' and 'password' are defined and empty",
                "keyActualValue": 	"Attributes 'username' and 'password' are not empty"
              }
}