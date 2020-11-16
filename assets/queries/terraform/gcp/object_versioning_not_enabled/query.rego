package Cx

CxPolicy [ result ] {
  
  resource := input.document[i].resource.google_storage_bucket[name]
  
  not resource.versioning

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_storage_bucket[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'versioning.enabled' equal to 'true'",
                "keyActualValue": 	"'versioning' field not found"
              }
}

CxPolicy [ result ] {
  
  resource := input.document[i].resource.google_storage_bucket[name]
  
  resource.versioning.enabled == "false"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_storage_bucket[%s].versioning.enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'versioning.enabled' equal to 'true'",
                "keyActualValue": 	"'versioning.enabled' equal to 'false'"
              }
}