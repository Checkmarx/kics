package Cx

CxPolicy [ result ] {
   document := input.document
   resource := document[i].Resources[name]
   resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
   properties := resource.Properties
   security_groups := properties.SecurityGroups
   finding_security_groups(document[i].Resources, security_groups)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.SecurityGroups", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": "All inbound rules contain port 22, tcp protocol and number of hosts > 32",
                "keyActualValue": 	"One of the inbound rules does not contain port 22, tpc protocol or number of hosts < 32"
              }
}
CxPolicy [ result ] {
   document := input.document
   resource := document[i].Resources[name]
   resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
   properties := resource.Properties
   security_groups := properties.SecurityGroups
   finding_security_groups(document[i].Resources, security_groups)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.SecurityGroups", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": "All inbound rules contain port 22, tcp protocol and number of hosts > 32",
                "keyActualValue": 	"One of the inbound rules does not contain port 22, tpc protocol or number of hosts < 32"
              }
}

finding_security_groups(resource, sc) {
   resource[sc_name].Type == "AWS::EC2::SecurityGroup"
   sc_name == sc[_]
   check_inbound_rules(resource[sc_name].Properties.SecurityGroupIngress)
}

check_inbound_rules(sc) {
	sc[_].IpProtocol != "tcp"
}

check_inbound_rules(sc) {
	sc[_].ToPort != 22
}

check_inbound_rules(sc) {
	sc[_].FromPort != 22
}

check_inbound_rules(sc) {
	cidrIp := split(sc[_].CidrIp, "/")[1]
	to_number(cidrIp) < 26 #by cidr notation
}