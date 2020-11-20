package Cx

CxPolicy [ result ] {
  storageBucket := input.document[i].resource.google_storage_bucket[name]
  storageBucket.uniform_bucket_level_access == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_storage_bucket[%s].uniform_bucket_level_access", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is true", [name]),
                "keyActualValue": 	sprintf("google_storage_bucket[%s].uniform_bucket_level_access is false", [name]),
              }
}

CxPolicy [ result ] {
  storageBucket := input.document[i].resource.google_storage_bucket[name]
  object.get(storageBucket, "uniform_bucket_level_access", "undefined") == "undefined"
    
	result := {
                "documentId": input.document[i].id,
                "searchKey": sprintf("google_storage_bucket[%s].uniform_bucket_level_access", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is defined", [name]),
                "keyActualValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is undefined", [name])
              }
}