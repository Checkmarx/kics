package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resources := document.Resources[name]
	resources.Type == "AWS::KMS::Key"
	policy := resources.Properties.KeyPolicy
	st := common_lib.get_statement(common_lib.get_policy(policy))
	some statement in st

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "kms:*")

	result := {
		"documentId": document.id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.KeyPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement should not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement has wildcard in 'Action' and 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "KeyPolicy"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resources := document.Resources[name]
	resources.Type == "AWS::KMS::Key"

	not common_lib.valid_key(resources.Properties, "KeyPolicy")

	result := {
		"documentId": document.id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KeyPolicy should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KeyPolicy is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties"], []),
	}
}
