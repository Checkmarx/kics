package Cx


CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]


  resource.kinesis_source_configuration
 
  resource.server_side_encryption.enabled == true
 
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled", [name]),
                "issueType":         "IncorrectValue",
                "keyExpectedValue":  "Attribute 'server_side_encryption' is enabled and attribute 'kinesis_source_configuration' is undefined",
                "keyActualValue":    "Attribute 'server_side_encryption' is enabled and attribute 'kinesis_source_configuration' is set"
            }
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

  not resource.server_side_encryption

  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("aws_kinesis_firehose_delivery_stream[%s]", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'server_side_encryption' is set",
                "keyActualValue":    "Attribute 'server_side_encryption' is undefined"
            }
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]


  not resource.kinesis_source_configuration
  resource.server_side_encryption
  resource.server_side_encryption.enabled != true

  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled", [name]),
                "issueType":         "IncorrectValue",
                "keyExpectedValue":  "Attribute 'server_side_encryption' is enabled and attribute 'kinesis_source_configuration' is undefined",
                "keyActualValue":    "Attribute 'server_side_encryption' is not enabled and attribute 'kinesis_source_configuration' is undefined"
            }
}




isValidKeyType(key_type) = allow {
       key_type == "AWS_OWNED_CMK"
       allow = true
}


isValidKeyType(key_type) = allow {
       key_type == "CUSTOMER_MANAGED_CMK"
       allow = true
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]


  not resource.kinesis_source_configuration
  
  resource.server_side_encryption.enabled == true
  
  key_type := resource.server_side_encryption.key_type
 
  not isValidKeyType(key_type)

  result := {
                "documentId":         input.document[i].id,
                "searchKey":          sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.key_type", [name]),
                "issueType":          "IncorrectValue",
                "keyExpectedValue":   "Attribute 'key_type' is valid",
                "keyActualValue":     "Attribute 'key_type' is invalid"
            }
}





CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]


  not resource.kinesis_source_configuration
  resource.server_side_encryption.enabled == true
 
  key_type := resource.server_side_encryption.key_type
 
  isValidKeyType(key_type)
 
  key_type == "CUSTOMER_MANAGED_CMK"
 
  not resource.server_side_encryption.key_arn
 

  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'key_type' is CUSTOMER_MANAGED_CMK and attribute 'key_arn' is set",
                "keyActualValue":    "Attribute 'key_type' is CUSTOMER_MANAGED_CMK and attribute 'key_arn' is undefined"
            }
}