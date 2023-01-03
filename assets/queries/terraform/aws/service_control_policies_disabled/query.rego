package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	org := input.document[i].resource.aws_organizations_organization[name]

	org.feature_set == "CONSOLIDATED_BILLING"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_organizations_organization",
		"resourceName": tf_lib.get_resource_name(org, name),
		"searchKey": sprintf("aws_organizations_organization[%s].feature_set", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'feature_set' should be set to 'ALL' or undefined",
		"keyActualValue": "'feature_set' is set to 'CONSOLIDATED_BILLING'",
		"searchLine": common_lib.build_search_line(["resource", "aws_organizations_organization", name, "feature_set"], []),
		"remediation": json.marshal({
			"before": "CONSOLIDATED_BILLING",
			"after": "ALL"
		}),
		"remediationType": "replacement",
	}
}
