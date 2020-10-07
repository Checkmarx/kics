package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_sqs_queue[name]
    object.get(resource, "kms_master_key_id", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "!null",
                "keyActualValue": 	"null",
                "value":            resource.name
              })
}
