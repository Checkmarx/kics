package Cx

CxPolicy [ result ] {
  domain := input.document[i].resource.aws_elasticsearch_domain[name]
  rest := domain.encrypt_at_rest

  not rest.kms_key_id

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain[%s].encrypt_at_rest", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'aws_elasticsearch_domain[%s].encrypt_at_rest.kms_key_id' is set with encryption at rest",[name]),
                "keyActualValue": sprintf("'aws_elasticsearch_domain[%s].encrypt_at_rest.kms_key_id' is undefined", [name])
              }
}