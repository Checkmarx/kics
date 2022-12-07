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
	values := [x | 
    vpc_endpoint_policy := input.document[_].resource.aws_vpc_endpoint_policy[_]
    policy := common_lib.json_unmarshal(vpc_endpoint_policy.policy)
    x := policy_accessibility(policy, resource.name)]
    info := get_info(values)
} else = info {
	info := {"accessibility":"private", "policy": ""}
}

policy_accessibility(policy, table_name) = info {
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.any_principal(statement.Principal)
	check_actions(statement.Action)

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

dynamo_actions := {
	"dynamodb:DescribeContributorInsights",
	"dynamodb:RestoreTableToPointInTime",
	"dynamodb:UpdateGlobalTable",
	"dynamodb:DeleteTable",
	"dynamodb:UpdateTableReplicaAutoScaling",
	"dynamodb:DescribeTable",
	"dynamodb:PartiQLInsert",
	"dynamodb:GetItem",
	"dynamodb:DescribeContinuousBackups",
	"dynamodb:DescribeExport",
	"dynamodb:ListImports",
	"dynamodb:EnableKinesisStreamingDestination",
	"dynamodb:BatchGetItem",
	"dynamodb:DisableKinesisStreamingDestination",
	"dynamodb:UpdateTimeToLive",
	"dynamodb:BatchWriteItem",
	"dynamodb:PutItem",
	"dynamodb:PartiQLUpdate",
	"dynamodb:Scan",
	"dynamodb:StartAwsBackupJob",
	"dynamodb:UpdateItem",
	"dynamodb:UpdateGlobalTableSettings",
	"dynamodb:CreateTable",
	"dynamodb:RestoreTableFromAwsBackup",
	"dynamodb:GetShardIterator",
	"dynamodb:DescribeReservedCapacity",
	"dynamodb:ExportTableToPointInTime",
	"dynamodb:DescribeBackup",
	"dynamodb:UpdateTable",
	"dynamodb:GetRecords",
	"dynamodb:DescribeTableReplicaAutoScaling",
	"dynamodb:DescribeImport",
	"dynamodb:ListTables",
	"dynamodb:DeleteItem",
	"dynamodb:PurchaseReservedCapacityOfferings",
	"dynamodb:CreateTableReplica",
	"dynamodb:ListTagsOfResource",
	"dynamodb:UpdateContributorInsights",
	"dynamodb:CreateBackup",
	"dynamodb:UpdateContinuousBackups",
	"dynamodb:DescribeReservedCapacityOfferings",
	"dynamodb:TagResource",
	"dynamodb:PartiQLSelect",
	"dynamodb:CreateGlobalTable",
	"dynamodb:DescribeKinesisStreamingDestination",
	"dynamodb:DescribeLimits",
	"dynamodb:ImportTable",
	"dynamodb:ListExports",
	"dynamodb:UntagResource",
	"dynamodb:ConditionCheckItem",
	"dynamodb:ListBackups",
	"dynamodb:Query",
	"dynamodb:DescribeStream",
	"dynamodb:DeleteTableReplica",
	"dynamodb:DescribeTimeToLive",
	"dynamodb:ListStreams",
	"dynamodb:ListContributorInsights",
	"dynamodb:DescribeGlobalTableSettings",
	"dynamodb:ListGlobalTables",
	"dynamodb:DescribeGlobalTable",
	"dynamodb:RestoreTableFromBackup",
	"dynamodb:DeleteBackup",
	"dynamodb:PartiQLDelete",
	"dynamodb:*"
}

check_actions(actions) {
	common_lib.equalsOrInArray(actions, dynamo_actions[_])
} else {
	common_lib.equalsOrInArray(actions, "*")
}

get_info(info_arr)= info{
	val := [ x | info_arr[x].accessibility == "public" ]
	info := info_arr[val[0]]
} else = info{
	info := info_arr[0]
}



