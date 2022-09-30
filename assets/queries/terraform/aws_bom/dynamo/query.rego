package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_dynamodb_table[name]

	info := get_accessibility(resource, name)

	bom_output = {
		"resource_type": "aws_dynamodb_table",
		"resource_name": tf_lib.get_specific_resource_name(resource, "aws_dynamodb_table", name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": get_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output = common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dynamodb_table[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_dynamodb_table", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_accessibility(resource, name) = info{
	vpc_endpoint_policy := input.document[_].resource.aws_vpc_endpoint_policy[_]

	policy := common_lib.json_unmarshal(vpc_endpoint_policy.policy)
	info := policy_accessibility(policy, resource.name)
} else = info {
	info := {"accessibility":"private", "policy": ""}
}

policy_accessibility(policy, table_name) = info {
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.any_principal(statement.Principal)

	resources_arn := get_resource_arn(statement.Resource)
	has_all_or_dynamob_arn(resources_arn, table_name)
	

	info := {"accessibility":"public", "policy": policy}
} else  = info {
	common_lib.get_statement(policy)
	info := {"accessibility":"private", "policy": policy}
} else = info {
	info := {"accessibility":"hasPolicy", "policy": policy}
}

has_all_or_dynamob_arn(arn, table_name){
	arn == "*"
} else {
	startswith(arn, "arn:aws:dynamodb:")
	suffix := concat( "", [":table/", table_name])
	endswith(arn, suffix)
}

get_resource_arn(resources) = val {
	is_array(resources)
	val := resources[_]
} else = val {
	val := resources
}

get_encryption(resource) = encryption{
	sse := resource.server_side_encryption
	sse.enabled == true
	encryption := "encrypted"
} else = encryption{
	encryption := "unencrypted"
}




