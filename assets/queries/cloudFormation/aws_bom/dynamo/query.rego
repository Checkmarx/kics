package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource := document[i].Resources[name]
	resource.Type == "AWS::DynamoDB::Table"

	info := get_accessibility(resource)

	bom_output = {
		"resource_type": "AWS::DynamoDB::Table",
		"resource_name": cf_lib.get_resource_name(resource, name),
		"resource_accessibility": lower(info.accessibility),
		"resource_encryption": get_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_accessibility(resource) = info{
	info:= check_vpc_endpoint(resource)
} else = info {
	info := {"accessibility":"private", "policy": ""}
}

check_vpc_endpoint(resource) = info{
	vpc_endpoint := input.document[_].Resources[_]
	vpc_endpoint.Type == "AWS::EC2::VPCEndpoint"

	policy_doc := vpc_endpoint.Properties.PolicyDocument

	info := policy_accessibility(policy_doc, resource.Properties.TableName)
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

get_resource_arn(resources) = val {
	is_array(resources)
	val := resources[_]
} else = val {
	val := resources
}

has_all_or_dynamob_arn(arn, table_name){
	arn == "*"
} else {
	startswith(arn, "arn:aws:dynamodb:")
	suffix := concat( "", [":table/", table_name])
	endswith(arn, suffix)
}

get_encryption(resource) = encryption{
    sse := resource.Properties.SSESpecification
    sse.SSEEnabled == true
    encryption := "encrypted"
} else = encryption{
    encryption := "unencrypted"
}
