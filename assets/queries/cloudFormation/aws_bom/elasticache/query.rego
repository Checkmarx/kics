package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	elasticache := document[i].Resources[name]
	elasticache.Type == "AWS::ElastiCache::CacheCluster"

	bom_output = {
		"resource_type": "AWS::ElastiCache::CacheCluster",
		"resource_name": cf_lib.get_resource_name(elasticache, name),
		# memcached or redis
		"resource_engine": elasticache.Properties.Engine,
		"resource_accessibility": get_accessibility(elasticache),
		"resource_encryption": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "In Memory Data Structure",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(bom_output),
	}
}

get_accessibility(elasticache) = accessibility {
	count({
		x | securityGroupInfo := cf_lib.get_name(elasticache.Properties.CacheSecurityGroupNames[x]);
		is_unrestricted(securityGroupInfo)
	}) > 0

	accessibility := "at least one security group associated with the elasticache is unrestricted"
} else = accessibility {
	count({
		x | securityGroupInfo := cf_lib.get_name(elasticache.Properties.CacheSecurityGroupNames[x]);
		not is_unrestricted(securityGroupInfo)
	}) == count(elasticache.Properties.CacheSecurityGroupNames)

	accessibility := "all security groups associated with the elasticache are restricted"
} else = accessibility {
	accessibility := "unknown"
}

is_unrestricted(securityGroupName) {
	document := input.document
	ingress := document[j].Resources[_]
    ingress.Type == "AWS::ElastiCache::SecurityGroupIngress"

	securityElastiCacheGroupName := cf_lib.get_name(ingress.Properties.CacheSecurityGroupName)

	securityElastiCacheGroupName == securityGroupName

	ec2SecurityGroupName := cf_lib.get_name(ingress.Properties.EC2SecurityGroupName)

	ec2SecurityGroup := document[d].Resources[ec2SecurityGroupName]
	ec2SecurityGroup.Type == "AWS::EC2::SecurityGroup"

	unrestricted_cidr(ec2SecurityGroup)
}

unrestricted_cidr(ec2SecurityGroup) {
	options := {"0.0.0.0/0", "::/0"}
	ec2SecurityGroup.Properties.SecurityGroupIngress[j].CidrIp == options[_]
}


