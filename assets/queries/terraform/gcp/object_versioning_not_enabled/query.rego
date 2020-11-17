package Cx

CxPolicy [ result ] {
  
  resource := input.document[i].resource.google_storage_bucket[name]
  
  object.get(resource, "versioning", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_storage_bucket[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'versioning' is defined",
                "keyActualValue": 	"'versioning' it undefined"
              }
}

CxPolicy [ result ] {
  
  resource := input.document[i].resource.google_storage_bucket[name]
  
  resource.versioning.enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_storage_bucket[%s].versioning.enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'versioning.enabled' is true",
                "keyActualValue": 	"'versioning.enabled' is false"
              }
}