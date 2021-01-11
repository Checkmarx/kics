package Cx

isAccessibleFromEntireNetwork(ingress) {
  endswith(ingress.CidrIp, "/0")
}

getProtocolList(protocol) = list {
  upper(protocol) == ["-1", "ALL"][_]
  list = ["TCP","UDP"]
} else = list {
  upper(protocol) == "TCP"
  list = ["TCP"]
} else = list {
  upper(protocol) == "UDP"
  list = ["UDP"]
}

getProtocolPorts(protocols, tcpPortsMap, udpPortsMap) = portsMap {
  protocols[_] == ["-1", "ALL"][_]
  portsMap = object.union(tcpPortsMap, udpPortsMap)
} else = portsMap {
  protocols[_] == "UDP"
  portsMap = udpPortsMap
} else = portsMap {
  protocols[_] == "TCP"
  portsMap = tcpPortsMap
}

CxPolicy [ result ] {
  #############	inputs

  # Dictionary of TCP ports
  tcpPortsMap =	{
    22: "SSH",
    23: "Telnet",
    25: "SMTP",
    110: "POP3",
    135: "MSSQL Debugger",
    137: "NetBIOS Name Service",
    138: "NetBIOS Datagram Service",
    139: "NetBIOS Session Service",
    389: "LDAP",
    445: "Microsoft-DS",
    636: "LDAP SSL",
    1433: "MSSQL Server",
    1434: "MSSQL Browser",
    1521: "Oracl DB",
    2382: "SQL Server Analysis",
    2383: "SQL Server Analysis",
    2483: "Oracle DB SSL",
    2484: "Oracle DB SSL",
    3000: "Prevalent known internal port",
    3020: "CIFS / SMB",
    3306: "MySQL",
    3389: "Remote Desktop",
    4505: "SaltStack Master",
    4506: "SaltStack Master",
    5432: "PostgreSQL",
    5500: "VNC Listener",
    5900: "VNC Server",
    6379: "Redis",
    7000: "Cassandra Internode Communication",
    7001: "Cassandra",
    7199: "Cassandra Monitoring",
    8000: "Known internal web port",
    8080: "Known internal web port",
    8140: "Puppet Master",
    8888: "Cassandra OpsCenter Website",
    9000: "Hadoop Name Node",
    9042: "Cassandra Client",
    9090: "CiscoSecure: WebSM",
    9160: "Cassandra Thrift",
    9200: "Elastic Search",
    9300: "Elastic Search",
    11211: "Memcached",
    11214: "Memcached SSL",
    11215: "Memcached SSL",
    27017: "Mongo",
    27018: "Mongo Web Portal",
    61620: "Cassandra OpsCenter",
    61621: "Cassandra OpsCenter"
  }

  # Dictionary of UDP ports
  udpPortsMap =	{
    53: "DNS",
    137: "NetBIOS Name Service",
    138: "NetBIOS Datagram Service",
    139: "NetBIOS Session Service",
    161: "SNMP",
    389: "LDAP",
    1434: "MSSQL Browser",
    2483: "Oracle DB SSL",
    2484: "Oracle DB SSL",
    5432: "PostgreSQL",
    11211: "Memcached",
    11214: "Memcached SSL",
    11215: "Memcached SSL"
  }

  #############	document and resource
  resources := input.document[i].Resources

  ec2InstanceList = [{"name": key, "properties": ec2Instance}|
                      ec2Instance := resources[key];
                      ec2Instance.Type == "AWS::EC2::Instance"]

  ec2Instance := ec2InstanceList[j]

  securityGroupList = [{"name": key, "properties": secGroup}|
                       secGroup := resources[key];
                       secGroup.Type == "AWS::EC2::SecurityGroup"]

  secGroup := securityGroupList[k]

  ec2Instance.properties.Properties.SecurityGroups[_] == secGroup["name"]

  ingress := secGroup.properties.Properties.SecurityGroupIngress[l]

  protocols := getProtocolList(ingress.IpProtocol)
  protocol := protocols[m]
  portsMap = getProtocolPorts(protocols, tcpPortsMap, udpPortsMap)

  #############	Checks
  isAccessibleFromEntireNetwork(ingress)

  # is in ports range
  portRange := numbers.range(ingress.FromPort, ingress.ToPort)
  portsMap[portRange[idx]]
  portNumber = portRange[idx]
  portName := portsMap[portNumber]

  #############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [secGroup["name"]]),
    "searchValue": sprintf("%s,%s", [protocol, portNumber]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in EC2 security group for instance %s", [portName, protocol, portNumber, ec2Instance["name"]]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in EC2 security group for instance %s", [portName, protocol, portNumber, ec2Instance["name"]])
  }
}
