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
    [22, "SSH"],
    [23, "Telnet"],
    [25, "SMTP"],
    [110, "POP3"],
    [135, "MSSQL Debugger"],
    [137, "NetBIOS Name Service"],
    [138, "NetBIOS Datagram Service"],
    [139, "NetBIOS Session Service"],
    [389, "LDAP"],
    [445, "Microsoft-DS"],
    [636, "LDAP SSL"],
    [1433, "MSSQL Server"],
    [1434, "MSSQL Browser"],
    [1521, "Oracl DB"],
    [2382, "SQL Server Analysis"],
    [2383, "SQL Server Analysis"],
    [2483, "Oracle DB SSL"],
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
    [61620, "Cassandra OpsCenter"],
    [61621, "Cassandra OpsCenter"]
  ]

  #############	document and resource
  allResources := input.document[i].Resources
  securityGroupName = [key | secGroup := allResources[key]; secGroup.Type == "AWS::EC2::SecurityGroup"; count(secGroup.Properties.SecurityGroupIngress) > 0][m]
  securityGroup = allResources[securityGroupName]
  ingress := getIngress(securityGroup)[n]

  #############	get relevant fields
  portNumber = portNumbers[j][0]
  portName = portNumbers[j][1]
  upper(ingress.IpProtocol) == "TCP"

  #############	Checks
  isAccessibleFromEntireNetwork(ingress)
  containsDestinationPort(portNumber, ingress)

  #############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [securityGroupName]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in EC2 security group for instance", [portName, "TCP", portNumber]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in EC2 security group for instance", [portName, "TCP", portNumber])
  }
}
