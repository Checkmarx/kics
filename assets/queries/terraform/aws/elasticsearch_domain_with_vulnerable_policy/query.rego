package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain_policy[name]

	policy := commonLib.json_unmarshal(resource.access_policies)
	statement := policy.Statement[_]

	terraLib.has_wildcard(statement, "es:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain_policy[%s].access_policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies does not have wildcard in 'Action' or 'Principal'", [name]),
		"keyActualValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies has wildcard in 'Action' or 'Principal'", [name]),
	}
}
