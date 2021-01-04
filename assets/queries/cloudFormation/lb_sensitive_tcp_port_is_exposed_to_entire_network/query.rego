package Cx

getELBType(elb) = type {
  object.get(elb.Properties, "Type", "unspecified") != "unspecified"
  type = elb.Properties.Type
} else = type {
  elb.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
  type = "classic"
} else = type {
  elb.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
  type = "application"
}

CxPolicy[result] {
  #############	inputs
  # List of ports
  portNumbers =	{
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
    27017: "MongoDB",
    27018: "MongoDB Web Portal",
    61620: "Cassandra OpsCenter",
    61621: "Cassandra OpsCenter"
  }

  #############	document and resource
  resources := input.document[i].Resources
  loadBalancerList := [{"name": key, "properties": loadBalancer}|
                       loadBalancer := resources[key];
                       contains(loadBalancer.Type, "ElasticLoadBalancing")]

  elb := loadBalancerList[j]
  elbType := getELBType(elb.properties)

  securityGroupList = [{"name": key, "properties": secGroup}|
                       secGroup := resources[key];
                       contains(secGroup.Type, "SecurityGroup")]

  secGroup := securityGroupList[k]
  ingress := secGroup.properties.Properties.SecurityGroupIngress[l]

  #############	get relevant fields
  upper(ingress.IpProtocol) == "TCP"

  #############	Checks
  endswith(ingress.CidrIp, "/0")
  portRange := numbers.range(ingress.FromPort, ingress.ToPort)
  portNumbers[portRange[idx]]
  portNumber = portRange[idx]
  portName := portNumbers[portNumber]

  ##############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [secGroup["name"]]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s load balancer %s", [portName, "TCP", portNumber, elbType, elb["name"]]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in %v load balancer %s", [portName, "TCP", portNumber, elbType, elb["name"]])
  }
}
