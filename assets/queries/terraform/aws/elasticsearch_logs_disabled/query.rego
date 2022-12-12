package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
	not common_lib.valid_key(awsElasticsearchDomain, "log_publishing_options")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(awsElasticsearchDomain, name),
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_publishing_options' should be defined and not null",
		"keyActualValue": "'log_publishing_options' is undefined or null",
		"remediation": "log_publishing_options {\n\t\t enabled = true \n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
	awsElasticsearchDomain.log_publishing_options.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(awsElasticsearchDomain, name),
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}].log_publishing_options.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "log_publishing_options", "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_publishing_options.enabled' should be true",
		"keyActualValue": "'log_publishing_options.enabled' is false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
