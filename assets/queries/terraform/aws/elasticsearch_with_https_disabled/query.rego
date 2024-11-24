package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_elasticsearch_domain[name]
	resource.domain_endpoint_options.enforce_https == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "domain_endpoint_options", "enforce_https"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The attribute 'enforce_https' should be set to 'true'",
		"keyActualValue": "The attribute 'enforce_https' is set to 'false'",
	}
}
