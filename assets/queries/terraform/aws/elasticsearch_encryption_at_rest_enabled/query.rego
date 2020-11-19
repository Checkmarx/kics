package Cx

CxPolicy [ result ] {
  domain := input.document[i].resource.aws_elasticsearch_domain[name]
  
  not domain.encrypt_at_rest

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'encrypt_at_rest' is set and enabled",
                "keyActualValue": 	"'encrypt_at_rest' is undefined"
              }
}

CxPolicy [ result ] {
  domain := input.document[i].resource.aws_elasticsearch_domain[name]
  encrypt_at_rest := domain.encrypt_at_rest

  encrypt_at_rest.enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain[%s].encrypt_at_rest.enabled", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'encrypt_at_rest.enabled' is true",
                "keyActualValue": 	"'encrypt_at_rest.enabled' is false"
              }
}