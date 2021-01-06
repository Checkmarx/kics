package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_db_instance[name]
    not resource.storage_encrypted
    not resource.kms_key_id

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_db_instance[%s].storage_encrypted", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_db_instance.storage_encrypted'  is true",
                "keyActualValue": 	"'aws_db_instance.storage_encrypted' is false"
              }
}
