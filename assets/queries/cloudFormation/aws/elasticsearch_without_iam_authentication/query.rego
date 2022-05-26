package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	policy := properties.AccessPolicies
	st := policy.Statement[idx]

	common_lib.any_principal(st)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AccessPolicies.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Elasticsearch Domain ensure IAM Authentication",
		"keyActualValue": "Elasticsearch Domain does not ensure IAM Authentication",
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "AccessPolicies", "Statement", idx], []),
	}
}
