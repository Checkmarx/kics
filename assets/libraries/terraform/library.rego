package generic.terraform

portNumbers := [
	[22, "SSH"],
	[23, "Telnet"],
	[25, "SMTP"],
	[53, "DNS"],
	[80, "HTTP"],
	[110, "POP3"],
	[135, "MSSQL Debugger"],
	[137, "NetBIOS Name Service"],
	[138, "NetBIOS Datagram Service"],
	[139, "NetBIOS Session Service"],
	[161, "SNMP"],
	[389, "LDAP"],
	[443, "HTTPS"],
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
	[5985, "WinRM for HTTP"],
	[5986, "WinRM for HTTPS"],
	[6379, "Redis"],
	[7000, "Cassandra Internode Communication"],
	[7001, "Cassandra"],
	[7199, "Cassandra Monitoring"],
	[8000, "Known internal web port"],
	[8080, "Known internal web port"],
	[8140, "Puppet Master"],
	[8443, "HTTPS Proxy"],
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

# Checks if a TCP port is open in a rule
openPort(rule, port) {
	rule.cidr_blocks[_] == "0.0.0.0/0"
	rule.protocol == "tcp"
	containsPort(rule, port)
}

openPort(rules, port) {
	rule := rules[_]
	rule.cidr_blocks[_] == "0.0.0.0/0"
	rule.protocol == "tcp"
	containsPort(rule, port)
}

# Checks if a port is included in a rule
containsPort(rule, port) {
	rule.from_port <= port
	rule.to_port >= port
}

else {
	rule.from_port == 0
	rule.to_port == 0
}

else {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), rule.destination_port_range)
}

else {
	ports := split(rule.destination_port_range, ",")
	sublist := split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
}

# Gets the list of protocols
getProtocolList("-1") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList("*") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "TCP"
	protocols := ["TCP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "UDP"
	protocols := ["UDP"]
}

# Checks if any principal are allowed ina policy
anyPrincipal(statement) {
	contains(statement.Principal, "*")
}

anyPrincipal(statement) {
	is_string(statement.Principal.AWS)
	contains(statement.Principal.AWS, "*")
}

anyPrincipal(statement) {
	is_array(statement.Principal.AWS)
	some i
	contains(statement.Principal.AWS[i], "*")
}
