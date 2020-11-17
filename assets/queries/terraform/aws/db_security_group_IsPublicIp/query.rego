package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_db_security_group[name].ingress
  resource.cidr
    
  not checkPrivateIps(resource.cidr)
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_db_security_group.ingress.cidr' == 10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12",
                "keyActualValue": 	"'aws_db_security_group.ingress.cidr' = 0.0.0.0/0"
              }
}

checkPrivateIps(ipVal) {
    private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    net.cidr_contains(private_ips[_], ipVal)
}