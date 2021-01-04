package Cx

CxPolicy [ result ] {
	some i
        not input.document[i].Resources[name].Type == "AWS::RDS::DBSecurityGroup"
        resource := input.document[i].Resources[name]
        resource.Type == "AWS::EC2::SecurityGroup"
        object.get(resource.Properties.SecurityGroupIngress, "CidrIpv6", "undefined") == "undefined"
        ipv4 := resource.Properties.SecurityGroupIngress.CidrIp
        not check_mask_ipv4(ipv4)

        result := {
                    "documentId": 		input.document[i].id,
                    "searchKey": 	    sprintf("Resources.%s.Properties.SecurityGroupIngress",  [name]),
                    "issueType":		"IncorrectValue", 
                    "keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' doesn't have more than 256 hosts.", [name]),
                    "keyActualValue": 	sprintf("'Resources.%s.Properties.SecurityGroupIngress' has more than 256 hosts.", [name]),
                  }
}

CxPolicy [ result ] {
	some i
        not input.document[i].Resources[name].Type == "AWS::RDS::DBSecurityGroup"
        resource := input.document[i].Resources[name]
        resource.Type == "AWS::EC2::SecurityGroup"
        object.get(resource.Properties.SecurityGroupIngress, "CidrIp", "undefined") == "undefined"
        ipv6 := resource.Properties.SecurityGroupIngress.CidrIpv6
        not check_ipv6(ipv6)

        result := {
                    "documentId": 		input.document[i].id,
                    "searchKey": 	    sprintf("Resources.%s.Properties.SecurityGroupIngress",  [name]),
                    "issueType":		"IncorrectValue", 
                    "keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' doesn't have more than 256 hosts.", [name]),
                    "keyActualValue": 	sprintf("'Resources.%s.Properties.SecurityGroupIngress' has more than 256 hosts.", [name]),
                  }
}

CxPolicy [ result ] {
	some i
        not input.document[i].Resources[name].Type == "AWS::EC2::SecurityGroup"
        resource := input.document[i].Resources[name]
        resource.Type == "AWS::RDS::DBSecurityGroup"
        ipv4 := resource.Properties.DBSecurityGroupIngress.CIDRIP
        not check_mask_ipv4(ipv4)

        result := {
                    "documentId": 		input.document[i].id,
                    "searchKey": 	    sprintf("Resources.%s.Properties.DBSecurityGroupIngress",  [name]),
                    "issueType":		"IncorrectValue", 
                    "keyExpectedValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' doesn't have more than 256 hosts.", [name]),
                    "keyActualValue": 	sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' has more than 256 hosts.", [name]),
                  }
}

check_mask_ipv4(ipv4){
	masks := {"25", "26", "27", "28", "29", "30", "31", "32"}
	output := split(ipv4, "/")
    masks[_] == output[1]
}

check_ipv6(ipv6){
	prefixes := {"120", "121", "122", "123", "124", "125", "126", "127", "128"}
    output := split(ipv6, "/")
    prefixes[_] == output[1]
}