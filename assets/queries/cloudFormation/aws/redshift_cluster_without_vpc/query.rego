package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
    # Case of missing VpcSecurityGroupIds and/or ClusterSubnetGroupName fields
	document := input.document[i]
	document.Resources[name].Type == "AWS::Redshift::Cluster"
	redshift_cluster := document.Resources[name]

    missing_fields := is_missing_fields(redshift_cluster.Properties)
    missing_fields != "false"

	result := {
		"documentId": document.id,
		"resourceType": "AWS::Redshift::Cluster",
		"resourceName": cf_lib.get_resource_name(document.Resources[name], name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties should have VpcSecurityGroupIds and ClusterSubnetGroupName fields defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties does not define %s", [name,missing_fields]),
        "searchLine": common_lib.build_search_line(["Resources", name ,"Properties"], []),
	}
}

CxPolicy[result] {
    # Case of invalid VpcSecurityGroupIds and ClusterSubnetGroupName references
	document := input.document[i]
	document.Resources[name].Type == "AWS::Redshift::Cluster"
	redshift_cluster := document.Resources[name]

    is_missing_fields(redshift_cluster.Properties) == "false"
    has_invalid_security_group(redshift_cluster.Properties.VpcSecurityGroupIds,document)
    has_invalid_subnet_group(redshift_cluster.Properties.ClusterSubnetGroupName,document)
    
    
	result := {
		"documentId": document.id,
		"resourceType": "AWS::Redshift::Cluster",
		"resourceName": cf_lib.get_resource_name(document.Resources[name], name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties VpcSecurityGroupIds and ClusterSubnetGroupName fields should have valid references", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties VpcSecurityGroupIds and ClusterSubnetGroupName fields have invalid references", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name ,"Properties"], []),
	}
}

CxPolicy[result] {
    # Case of invalid VpcSecurityGroupIds or ClusterSubnetGroupName reference
	document := input.document[i]
	document.Resources[name].Type == "AWS::Redshift::Cluster"
	redshift_cluster := document.Resources[name]

    is_missing_fields(redshift_cluster.Properties) == "false"
    invalid_field = get_single_invalid_field(redshift_cluster.Properties,document)
    invalid_field != "false"
    
    
	result := {
		"documentId": document.id,
		"resourceType": "AWS::Redshift::Cluster",
		"resourceName": cf_lib.get_resource_name(document.Resources[name], name),
		"searchKey": sprintf("Resources.%s.Properties.%s", [name,invalid_field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties VpcSecurityGroupIds and ClusterSubnetGroupName fields should have valid references", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties %s field has an invalid reference", [name,invalid_field]),
        "searchLine": common_lib.build_search_line(["Resources", name ,"Properties", invalid_field], []),
	}
}

is_missing_fields(properties) = "VpcSecurityGroupIds or ClusterSubnetGroupName" {
    not common_lib.valid_key(properties,"VpcSecurityGroupIds")
    not common_lib.valid_key(properties,"ClusterSubnetGroupName")
} else = "VpcSecurityGroupIds" {
    not common_lib.valid_key(properties,"VpcSecurityGroupIds")
} else = "ClusterSubnetGroupName" {
    not common_lib.valid_key(properties,"ClusterSubnetGroupName")
} else = "false"

get_single_invalid_field(properties,doc) = "false" {
    has_invalid_security_group(properties.VpcSecurityGroupIds,doc)
    has_invalid_subnet_group(properties.ClusterSubnetGroupName,doc)
} else = "VpcSecurityGroupIds" {
    has_invalid_security_group(properties.VpcSecurityGroupIds,doc)
} else = "ClusterSubnetGroupName" {
    has_invalid_subnet_group(properties.ClusterSubnetGroupName,doc)
} else = "false"

has_invalid_subnet_group(ClusterSubnetGroupName,doc) = true {
    not common_lib.valid_key(doc.Resources,cf_lib.get_name(ClusterSubnetGroupName))
} else = true {
    doc.Resources[cf_lib.get_name(ClusterSubnetGroupName)].Type != "AWS::Redshift::ClusterSubnetGroup"
} else = false
 
has_invalid_security_group(VpcSecurityGroupIds,doc) = true {
    group_id := cf_lib.get_name(VpcSecurityGroupIds[id])
    not common_lib.valid_key(doc.Resources,group_id)
} else = true {
    group_id := cf_lib.get_name(VpcSecurityGroupIds[id])
    doc.Resources[group_id].Type != "AWS::EC2::SecurityGroup"
} else = false 


