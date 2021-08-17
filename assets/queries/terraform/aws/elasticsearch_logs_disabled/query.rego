package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
	not common_lib.valid_key(awsElasticsearchDomain, "log_publishing_options")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_elasticsearch_domain' has log_publishing_options defined and not null",
		"keyActualValue": "'log_publishing_options.enabled' has not log_publishing_options undefined or null",
	}
}

CxPolicy[result] {
	awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
	awsElasticsearchDomain.log_publishing_options.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}].log_publishing_options.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_publishing_options.enabled' is true",
		"keyActualValue": "'log_publishing_options.enabled' is false",
	}
}
