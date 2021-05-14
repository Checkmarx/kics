package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
	object.get(awsElasticsearchDomain, "log_publishing_options", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_elasticsearch_domain' has log_publishing_options defined",
		"keyActualValue": "'log_publishing_options.enabled' has not log_publishing_options defined",
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
