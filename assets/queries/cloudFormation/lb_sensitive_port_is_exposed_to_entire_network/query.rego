package Cx

getFieldName(field) = name {
  upper(field) == "NETWORK PORTS SECURITY"
  name = ["AWS::ElasticLoadBalancingV2::LoadBalancer", "AWS::ElasticLoadBalancing::LoadBalancer"]
}

getResource(document, field) = resource {
  theResource := document.Resources
  theResource[getName(theResource)]
  resource = theResource
}

getDocument([]) = document {
  document := input.document
}

getSecurityGroup(resource, groupName) = securityGroup {
  group = resource[securityGroupName]
  group.Type = "AWS::EC2::SecurityGroup"
  securityGroup = group
}

getSecurityGroupName(resource) = name {
  name = resource[_].Properties.SecurityGroups[_]
}

getName(resource) = name {
  subResource = resource[theName]
  subResource.Type == getFieldName("NETWORK PORTS SECURITY")[_]
  name = theName
}

getIngress(securityGroup) = ingress {
  ingress = securityGroup.Properties.SecurityGroupIngress
}

getELBType(name, resource) = type {
  object.get(resource[name].Properties, "Type", "unspecified") != "unspecified"
  type = resource[name].Properties.Type
} else = type {
  resource[name].Type == "AWS::ElasticLoadBalancing::LoadBalancer"
  type = "classic"
} else = type {
  resource[name].Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
  type = "application"
}

getProtocol(ingress) = protocol {
  protocol = ingress.IpProtocol
}

getProtocolList(protocol) = list {
  upper(protocol) == ["-1", "ALL"][_]
  list = ["TCP","UDP","Icmp","icmpv6"]
} else = list {
  upper(protocol) == "TCP"
  list = ["TCP"]
} else = list {
  upper(protocol) == "UDP"
  list = ["UDP"]
} else = list {
  upper(protocol) == "ICMP"
  list = ["Icmp"]
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

isTCPorUDP(protocol) {
  tcpUdp = ["TCP","UDP"]
  upper(protocol) == tcpUdp[_]
}

CxPolicy [ result ] {
  #############	inputs
  # List of ports
  portNumbers =	[
    [22, "SSH"],
    [23, "Telnet"],
    [25, "SMTP"],
    [53, "DNS"],
    [110, "POP3"],
    [135, "MSSQL Debugger"],
    [137, "NetBIOS Name Service"],
    [138, "NetBIOS Datagram Service"],
    [139, "NetBIOS Session Service"],
    [161, "SNMP"],
    [389, "LDAP"],
    [445, "Microsoft-DS"],
    [636, "LDAP SSL"],
    [1433, "MSSQL Server"],
    [1434, "MSSQL Browser"],
    [1521, "Oracl DB"],
    [2382, "SQL Server Analysis"],
    [2383, "SQL Server Analysis"],
    [2484, "Oracle DB SSL"],
    [3000, "Prevalent known internal port"],
    [3020, "CIFS / SMB"],
    [3306, "MySQL"],
    [3389, "Remote Desktop"],
    [4505, "SaltStack Master"],
    [4506, "SaltStack Master"],
    [5432, "PostgreSQL"],
    [5500, "VNC Listener"],
    [5900, "VNC Server"],
    [6379, "Redis"],
    [7000, "Cassandra Internode Communication"],
    [7001, "Cassandra"],
    [7199, "Cassandra Monitoring"],
    [8000, "Known internal web port"],
    [8080, "Known internal web port"],
    [8140, "Puppet Master"],
    [8888, "Cassandra OpsCenter Website"],
    [9000, "Hadoop Name Node"],
    [9042, "Cassandra Client"],
    [9090, "CiscoSecure, WebSM"],
    [9160, "Cassandra Thrift"],
    [9200, "Elastic Search"],
    [9300, "Elastic Search"],
    [11211, "Memcached"],
    [11214, "Memcached SSL"],
    [11215, "Memcached SSL"],
    [27017, "Mongo"],
    [27018, "Mongo Web Portal"],
    [61621, "Cassandra OpsCenter"]
  ]

  # Category/service used
  field = getFieldName("Network Ports Security")

  #############	document and resource
  document := getDocument([])[i]
  resource := getResource(document, field)
  name = getName(resource)
  elbType := getELBType(name, resource)
  securityGroupName = getSecurityGroupName(resource)
  securityGroup = getSecurityGroup(resource, securityGroupName)
  ingress := getIngress(securityGroup)[n]

  #############	get relevant fields
  portNumber = portNumbers[j][0]
  portName = portNumbers[j][1]

  protocolList = getProtocolList(getProtocol(ingress))
  protocol = protocolList[k]

  #############	Checks
  isAccessibleFromEntireNetwork(ingress)
  containsDestinationPort(portNumber, ingress)
  isTCPorUDP(protocol)

  #############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [securityGroupName]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s load balancer %s", [portName, protocol, portNumber, elbType, name]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in %v load balancer %s", [portName, protocol, portNumber, elbType, name])
  }
}
