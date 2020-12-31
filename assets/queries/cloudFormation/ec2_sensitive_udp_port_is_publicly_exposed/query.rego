package Cx

getIngress(securityGroup) = ingress {
  ingress = securityGroup.Properties.SecurityGroupIngress
}

isAccessibleFromEntireNetwork(ingress) {
  endswith(ingress.CidrIp, "/0")
}

containsDestinationPort(port, ingress) {
  ingress.FromPort == 0
  ingress.ToPort == 0
} else {
  port == numbers.range(ingress.FromPort, ingress.ToPort)[_]
}

CxPolicy [ result ] {
  #############	inputs
  # List of ports
  portNumbers =	[
    [53, "DNS"],
    [137, "NetBIOS Name Service"],
    [138, "NetBIOS Datagram Service"],
    [139, "NetBIOS Session Service"],
    [161, "SNMP"],
    [389, "LDAP"],
    [1434, "MSSQL Browser"],
    [2483, "Oracle DB SSL"],
    [2484, "Oracle DB SSL"],
    [5432, "PostgreSQL"],
    [11211, "Memcached"],
    [11214, "Memcached SSL"],
    [11215, "Memcached SSL"]
  ]

  #############	document and resource
  allResources := input.document[i].Resources
  securityGroupName = [key | secGroup := allResources[key]; secGroup.Type == "AWS::EC2::SecurityGroup"; count(secGroup.Properties.SecurityGroupIngress) > 0][m]
  securityGroup = allResources[securityGroupName]
  ingress := getIngress(securityGroup)[n]

  #############	get relevant fields
  portNumber = portNumbers[j][0]
  portName = portNumbers[j][1]
  upper(ingress.IpProtocol) == "UDP"

  #############	Checks
  isAccessibleFromEntireNetwork(ingress)
  containsDestinationPort(portNumber, ingress)

  #############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [securityGroupName]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in EC2 security group for instance", [portName, "UDP", portNumber]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in EC2 security group for instance", [portName, "UDP", portNumber])
  }
}
