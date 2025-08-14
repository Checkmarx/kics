package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource := document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	accessibility := get_resource_accessibility(resource)

	bom_output = {
		"resource_type": "AWS::RDS::DBInstance",
		"resource_name": cf_lib.get_resource_name(resource, name),
		"resource_engine": resource.Properties.Engine,
		"resource_accessibility": accessibility,
		"resource_encryption": get_db_instance_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, "")

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

## get accessibility functions
get_resource_accessibility(resource) = accessibility{
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
    accessibility:= "public"
} else = accessibility{
	cf_lib.isCloudFormationFalse(resource.Properties.PubliclyAccessible)
    accessibility:= "private"
} else = accessibility{
    not common_lib.valid_key(resource,"PubliclyAccessible")
    subnet_gp_name :=  resource.Properties.DBSubnetGroupName
	has_vpc_gateway_attached(subnet_gp_name)
	accessibility:= "public"
} else = accessibility{
    not common_lib.valid_key(resource.Properties,"PubliclyAccessible")
    common_lib.valid_key(resource.Properties, "DBSubnetGroupName")
	accessibility:= "private"
} else = accessibility{
    accessibility:= "unknown"
}

has_vpc_gateway_attached(subnet_gp_name){
	res_subnet_gp := input.document[_].Resources[subnet_gp_name]
	res_subnet_gp.Type == "AWS::RDS::DBSubnetGroup"
	subnet_name := res_subnet_gp.Properties.SubnetIds[_].Ref

	res_subnet := input.document[_].Resources[subnet_name]
	res_subnet.Type == "AWS::EC2::Subnet"
	vpc_name := res_subnet.Properties.VpcId.Ref
	
	res_vpc_gateway := input.document[_].Resources[_]
	res_vpc_gateway.Type == "AWS::EC2::VPCGatewayAttachment"
	res_vpc_gateway.Properties.VpcId == vpc_name	
}

## get encryption functions
get_db_instance_encryption(resource) = encryption{
	engine := lower(resource.Properties.Engine)
	not contains(engine, "aurora")
	encryption := get_enc_for_not_aurora(resource)
} else = encryption{
	engine := lower(resource.Properties.Engine)
	contains(engine, "aurora")
	encryption := get_enc_for_aurora(resource)
}

# get encytion for instances with engines that are not aurora 
get_enc_for_not_aurora(resource) = encryption{
	cf_lib.isCloudFormationTrue(resource.Properties.StorageEncrypted)
	encryption := "encrypted"
} else = encryption{
	cf_lib.isCloudFormationFalse(resource.Properties.StorageEncrypted)
	encryption := "unencrypted"
} else = encryption{
	not common_lib.valid_key(resource.Properties, "StorageEncrypted")
	dbInstanceIdentifier := cf_lib.get_name(resource.Properties.SourceDBInstanceIdentifier)

	res_subnet_gp := input.document[_].Resources[dbInstanceIdentifier]
	res_subnet_gp.Type == "AWS::RDS::DBInstance"	

	encryption := get_encryption(res_subnet_gp)
} else = encryption{
	not common_lib.valid_key(resource.Properties, "StorageEncrypted")
	dbInstanceIdentifier := cf_lib.get_name(resource.Properties.SnapshotIdentifier)

	res_subnet_gp := input.document[_].Resources[dbInstanceIdentifier]
	res_subnet_gp.Type == "AWS::RDS::DBInstance"	

	encryption := get_encryption(res_subnet_gp)
} else = encryption{
	encryption := "unencrypted"
}	

get_encryption(resource) = encryption{
	cf_lib.isCloudFormationTrue(resource.Properties.StorageEncrypted)
	encryption := "encrypted"
} else = encryption{
	encryption := "unencrypted"
}

#get encytion for instances with aurora engines
get_enc_for_aurora(resource) = encryption{
	cluster_name := resource.Properties.DBClusterIdentifier

	cluster := input.document[_].Resources[cluster_name]
	cluster.Type == "AWS::RDS::DBCluster"
	
	encryption := get_cluster_enc(cluster)
}

# get encytion for for the cluster
get_cluster_enc(resource)= encryption{
	cf_lib.isCloudFormationTrue(resource.Properties.StorageEncrypted)
	encryption := "encrypted"
} else = encryption{
	cf_lib.isCloudFormationFalse(resource.Properties.StorageEncrypted)
	encryption := "unencrypted"
} else = encryption{
	not common_lib.valid_key(resource.Properties, "SourceDBClusterIdentifier ")
	dbClusterIdentifier := cf_lib.get_name(resource.Properties.SourceDBClusterIdentifier)

	dbCluster := input.document[_].Resources[dbClusterIdentifier]
	dbCluster.Type == "AWS::RDS::DBCluster"	

	encryption := get_encryption(dbCluster)
} else = encryption{
	not common_lib.valid_key(resource.Properties, "StorageEncrypted")
	dbClusterIdentifier := cf_lib.get_name(resource.Properties.SnapshotIdentifier)

	dbCluster := input.document[_].Resources[dbClusterIdentifier]
	dbCluster.Type == "AWS::RDS::DBCluster"	

	encryption := get_encryption(dbCluster)
} else = encryption{
	encryption := "unencrypted"
}	
