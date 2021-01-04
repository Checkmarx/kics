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
  loadBalancerList := [{"name": key, "properties": loadBalancer}|
                       loadBalancer := resources[key];
                       contains(loadBalancer.Type, "ElasticLoadBalancing")]

  elb := loadBalancerList[j]
  elbType := getELBType(elb.properties)

  securityGroupList = [{"name": key, "properties": secGroup}|
                       secGroup := resources[key];
                       contains(secGroup.Type, "SecurityGroup")]

  secGroup := securityGroupList[k]
  ingress := secGroup.properties.Properties.SecurityGroupIngress

  #############	get relevant fields
  upper(ingress[l].IpProtocol) == "UDP"

  #############	Checks
  endswith(ingress[l].CidrIp, "/0")
  portRange := numbers.range(ingress[l].FromPort, ingress[l].ToPort)
  portNumbers[portRange[idx]]
  portNumber = portRange[idx]
  portName := portNumbers[portNumber]

  ##############	Result
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.SecurityGroupIngress", [secGroup["name"]]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s load balancer %s", [portName, "UDP", portNumber, elbType, elb["name"]]),
    "keyActualValue": sprintf("%s (%s:%d) is allowed in %v load balancer %s", [portName, "UDP", portNumber, elbType, elb["name"]])
  }
}
