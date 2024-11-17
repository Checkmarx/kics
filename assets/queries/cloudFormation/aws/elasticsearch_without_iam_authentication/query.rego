package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	policy := properties.AccessPolicies
	st := policy.Statement[idx]

	common_lib.any_principal(st)

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AccessPolicies.Statement", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Elasticsearch Domain should ensure IAM Authentication",
		"keyActualValue": "Elasticsearch Domain does not ensure IAM Authentication",
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "AccessPolicies", "Statement", idx]),
	}
}
