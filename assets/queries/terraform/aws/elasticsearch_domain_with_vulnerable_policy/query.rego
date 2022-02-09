package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain_policy[name]

	policy := common_lib.json_unmarshal(resource.access_policies)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	terra_lib.has_wildcard(statement, "es:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain_policy[%s].access_policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies does not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies has wildcard in 'Action' or 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain_policy", name, "access_policies"], []),
	}
}
