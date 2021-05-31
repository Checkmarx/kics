package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain_policy[name]

	policy := commonLib.json_unmarshal(resource.access_policies)
	statement := policy.Statement[_]

	terraLib.check_principal(statement.Principal)
	terraLib.check_action(statement.Action, "es:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain_policy[%s].access_policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies definition is correct", [name]),
		"keyActualValue": sprintf("aws_elasticsearch_domain_policy[%s].access_policies definition is incorrect", [name]),
	}
}
