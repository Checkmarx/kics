package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup","AWS::RDS::DBSecurityGroupIngress","AWS::EC2::SecurityGroupIngress"]
	public_db := input.document[i].Resources[name]
	is_public_dbinstance(public_db)
	resource := input.document[i].Resources[j]
	resource.Type == types[t]
	ingress_list := cf_lib.get_ingress_list(resource)
	results := exposed_inline_or_standalone_ingress(ingress_list[ing_index], ing_index, resource.Type, j)
	results != ""
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, j),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine" : results.searchLine,
	}
}

exposed_inline_or_standalone_ingress(res, ing_index, type, resource_index) = results { # inline ingresses 
	type == "AWS::EC2::SecurityGroup"
	res.CidrIp == "0.0.0.0/0" #ipv4

	results := {
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp", [resource_index, ing_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp' should not be '0.0.0.0/0'.", [resource_index,ing_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp' is '0.0.0.0/0'.", [resource_index,ing_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "SecurityGroupIngress", ing_index, "CidrIp"],[])
	}
} else = results {
	type == "AWS::EC2::SecurityGroup"
	res.CidrIpv6 == common_lib.unrestricted_ipv6[_] #ipv6

	results := {
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6", [resource_index, ing_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6' should not be '::/0'.", [resource_index,ing_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6' is '::/0'.", [resource_index,ing_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "SecurityGroupIngress", ing_index, "CidrIpv6"],[])
	}
} else = results {
	type == "AWS::RDS::DBSecurityGroup"
	res.CIDRIP == "0.0.0.0/0"  #ipv4 - legacy resource

	results := {
		"searchKey": sprintf("Resources.%s.Properties.DBSecurityGroupIngress[%d].CIDRIP", [resource_index, ing_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress[%d].CIDRIP' should not be '0.0.0.0/0'.", [resource_index,ing_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress[%d].CIDRIP' is '0.0.0.0/0'.", [resource_index,ing_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "DBSecurityGroupIngress", ing_index, "CIDRIP"],[])
	}
} else = results { # standalone ingress resources 
	type == "AWS::EC2::SecurityGroupIngress"
	res.CidrIp == "0.0.0.0/0"  #standalone ipv4

	results := {
		"searchKey": sprintf("Resources.%s.Properties.CidrIp", [resource_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.CidrIp' should not be '0.0.0.0/0'.", [resource_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.CidrIp' is '0.0.0.0/0'.", [resource_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "CidrIp"],[])
	}
} else = results {
	type == "AWS::EC2::SecurityGroupIngress"
	res.CidrIpv6 == common_lib.unrestricted_ipv6[_] #standalone ipv6

	results := {
		"searchKey": sprintf("Resources.%s.Properties.CidrIpv6", [resource_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.CidrIpv6' should not be '::/0'.", [resource_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.CidrIpv6' is '::/0'.", [resource_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "CidrIpv6"],[])
	}
} else = results {
	type == "AWS::RDS::DBSecurityGroupIngress"
	res.CIDRIP == "0.0.0.0/0" #standalone ipv4 - legacy resource
	results := {
		"searchKey": sprintf("Resources.%s.Properties.CIDRIP", [resource_index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.CIDRIP' should not be '0.0.0.0/0'.", [resource_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.CIDRIP' is '0.0.0.0/0'.", [resource_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "CIDRIP"],[])
	}
} else = ""

is_public_dbinstance(resource) {
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
} else {
	resource.Type == "AWS::RDS::DBInstance" 
	not common_lib.valid_key(resource.Properties, "PubliclyAccessible") #default value varies so true is assumed 
}
