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
	values := [x | 
		vpc_endpoint := input.document[_].Resources[_]
		vpc_endpoint.Type == "AWS::EC2::VPCEndpoint"
		policy_doc := vpc_endpoint.Properties.PolicyDocument
		x := policy_accessibility(policy_doc, resource.Properties.TableName)]

    info := get_info(values)
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
	cf_lib.isCloudFormationTrue(sse.SSEEnabled)
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
