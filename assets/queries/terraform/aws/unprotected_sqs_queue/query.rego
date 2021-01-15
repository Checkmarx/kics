package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_sqs_queue[name]
    object.get(resource, "kms_master_key_id", "not found") == "not found"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'kms_master_key_id' exists",
                "keyActualValue": 	"'kms_master_key_id' is missing",
                "value":            resource.name
              }
}
