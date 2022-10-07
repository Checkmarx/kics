package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]

	accessibility := get_accessibility(resource)

	bom_output = {
		"resource_type": "aws_db_instance",
		"resource_name": tf_lib.get_specific_resource_name(resource, "aws_db_instance", name),
		"resource_engine": get_engine(resource),
		"resource_accessibility": accessibility,
		"resource_encryption": get_db_instance_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output = common_lib.get_bom_output(bom_output, "")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
		"value": json.marshal(final_bom_output),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_rds_cluster_instance[name]

	bom_output = {
		"resource_type": "aws_rds_cluster_instance",
		"resource_name": tf_lib.get_specific_resource_name(resource, "aws_rds_cluster_instance", name),
		"resource_engine": get_rds_cluster_instance_engine(resource),
		"resource_accessibility": get_accessibility(resource),
		"resource_encryption": get_rds_cluster_instance_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output = common_lib.get_bom_output(bom_output, "")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_rds_cluster_instance[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster_instance", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_accessibility(resource) = info{
	resource.publicly_accessible == true
	info := "public"
} else = info{
	info := "private"
}

get_db_instance_encryption(resource)=encryption{
	resource.storage_encrypted == true
	encryption := "encrypted"
} else = encryption{
	encryption := "unencrypted"
}

get_rds_cluster_encryption(resource)=encryption{
	resource.storage_encrypted == true
	encryption := "encrypted"
} else = encryption{
	resource.engine_mode == "serverless"
	not common_lib.valid_key(resource, "storage_encrypted")
	encryption := "encrypted"
} else = encryption{
	encryption := "unencrypted"
}

get_rds_cluster_instance_encryption(resource)=encryption{
	cluster_name := split(resource.cluster_identifier, ".")[1] 
	cluster_resource := input.document[_].resource.aws_rds_cluster[cluster_name]
	encryption := get_rds_cluster_encryption(resource)
}

get_rds_cluster_instance_engine(resource) = engine{
	cluster_name := split(resource.engine, ".")[1] 
	cluster_resource := input.document[_].resource.aws_rds_cluster[cluster_name]
	engine := cluster_resource.engine
} else = engine{
	cluster_name := split(resource.engine, ".")[1] 
	cluster_resource := input.document[_].resource.aws_rds_cluster[cluster_name]
	not common_lib.valid_key(cluster_resource, "engine")
	engine := "unknown"
}

get_engine(resource) = engine {
	engine := resource.engine
} else = engine {
	not common_lib.valid_key(resource, "snapshot_identifier")
	replicate_source_db := resource.replicate_source_db
	source_db_name := split(replicate_source_db, ".")[1] 
	source_db := input.document[_].resource.aws_db_instance[source_db_name]
	engine := source_db.engine
} else = engine {
	engine := "unknown"
}
