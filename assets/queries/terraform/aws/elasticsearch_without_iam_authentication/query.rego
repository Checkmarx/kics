package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name]

	not has_policy(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticsearch_domain[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Elasticsearch Domain has a policy associated",
		"keyActualValue": "Elasticsearch Domain does not have a policy associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name]

	without_iam_auth(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticsearch_domain[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Elasticsearch Domain ensure IAM Authentication",
		"keyActualValue": "Elasticsearch Domain does not ensure IAM Authentication",
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
	}
}

has_policy(name) {
	policy := input.document[i].resource.aws_elasticsearch_domain_policy[_]
	split(policy.domain_name, ".")[1] == name
}

without_iam_auth(name) {
	policy := input.document[i].resource.aws_elasticsearch_domain_policy[_]
	split(policy.domain_name, ".")[1] == name

	p := common_lib.json_unmarshal(policy.access_policies)
	st := p.Statement[_]
	st.Effect == "Allow"
	common_lib.any_principal(st)
}
