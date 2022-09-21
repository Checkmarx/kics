package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	domain := input.document[i].resource.aws_elasticsearch_domain[name]
	rest := domain.encrypt_at_rest

	not rest.kms_key_id

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(domain, name),
		"searchKey": sprintf("aws_elasticsearch_domain[%s].encrypt_at_rest", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elasticsearch_domain[%s].encrypt_at_rest.kms_key_id' should be set with encryption at rest", [name]),
		"keyActualValue": sprintf("'aws_elasticsearch_domain[%s].encrypt_at_rest.kms_key_id' is undefined", [name]),
	}
}
