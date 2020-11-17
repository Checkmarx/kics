package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_db_security_group[name].ingress
  resource.cidr
    
  not checkPrivateIps(resource.cidr)
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'aws_db_security_group[%s].ingress.cidr' is [10.0.0.0/8] or [192.168.0.0/16] or [172.16.0.0/12]", [name]),
                "keyActualValue": sprintf("'aws_db_security_group[%s].ingress.cidr' is [%s]", [name, resource.cidr])
              }
}

checkPrivateIps(ipVal) {
    private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    net.cidr_contains(private_ips[_], ipVal)
}