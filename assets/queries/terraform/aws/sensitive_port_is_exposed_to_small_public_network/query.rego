package Cx

getFieldName(field) = name {
	upper(field) == "NETWORK PORTS SECURITY"
	name = "aws_security_group"
}

getResource(document, field) = resource {
	resource := document.resource[field]
}

getDocument([]) = document {
	document := input.document
}

getProtocol(resource) = protocol {
	protocol = resource.ingress.protocol
}

getProtocolList(protocol) = list {
	protocol == "-1"
	list = ["TCP", "UDP", "Icmp", "icmpv6"]
}

else = list {
	upper(protocol) == "TCP"
	list = ["TCP"]
}

else = list {
	upper(protocol) == "UDP"
	list = ["UDP"]
}

else = list {
	upper(protocol) == "ICMP"
	list = ["Icmp"]
}

containsDestinationPort(port, resource) = containing {
	portStart = resource.ingress.from_port
	portEnd = resource.ingress.to_port
	portStart <= port
	portEnd >= port
	containing = true
}

else = containing {
	resource.ingress.from_port == 0
	resource.ingress.to_port == 0
	containing = true
}

isSmallPublicNetwork(resource) = private {
	endswith(resource.ingress.cidr_blocks[_], "/25")
	private = true
} else = private {
	endswith(resource.ingress.cidr_blocks[_], "/26")
	private = true
} else = private {
	endswith(resource.ingress.cidr_blocks[_], "/27")
	private = true
} else = private {
	endswith(resource.ingress.cidr_blocks[_], "/28")
	private = true
} else = private {
	endswith(resource.ingress.cidr_blocks[_], "/29")
	private = true
}

isTCPorUDP(protocol) = is {
	tcpUdp = ["TCP", "UDP"]
	is = upper(protocol) == tcpUdp[_]
}

CxPolicy[result] {
	#############	inputs
	portNumbers = [
		[22, "SSH"], # List of ports
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
		[61621, "Cassandra OpsCenter"],
	]

	field = getFieldName("Network Ports Security") # Category/service used

	#############	document and resource
	document := getDocument([])[i]
	resource := getResource(document, field)[var0]

	#############	get relevant fields
	portNumber = portNumbers[j][0]
	portName = portNumbers[j][1]
	protocolList = getProtocolList(getProtocol(resource))
	protocol = protocolList[k]

	#############	Checks
	isSmallPublicNetwork(resource)
	containsDestinationPort(portNumber, resource)
	isTCPorUDP(protocol)

	#############	Result
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].ingress", [field, var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
	}
}
