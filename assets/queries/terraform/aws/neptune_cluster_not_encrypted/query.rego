package Cx

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_neptune_cluster[name]
  object.get(password_policy, "storage_encrypted", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_neptune_cluster[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'storage_encrypted' should be set with value true",
                "keyActualValue": 	"'storage_encrypted' is undefined"
              }
}

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_neptune_cluster[name]
  password_policy.storage_encrypted == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_neptune_cluster[%s].storage_encrypted", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'storage_encrypted' should be true",
                "keyActualValue": 	"'storage_encrypted' is false"
              }
}