package Cx

CxPolicy [ result ] {
  
  resource := input.document[i].resource.aws_sqs_queue[name]
  object.get(resource, "kms_master_key_id", "undefined") == "undefined"
  
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("aws_sqs_queue[%s]", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "aws_sqs_queue.kms_master_key_id is defined",
                "keyActualValue":   "aws_sqs_queue.kms_master_key_id is undefined"
              }
}

CxPolicy [ result ] {
  
  resource := input.document[i].resource.aws_sqs_queue[name]
  isKeyEmpty(resource.kms_master_key_id)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "aws_sqs_queue.kms_master_key_id not null or ''",
                "keyActualValue":   "aws_sqs_queue.kms_master_key_id null or ''"
              }
}

isKeyEmpty(key) {
	key == null
}
isKeyEmpty(key) {
	key == ""
}
