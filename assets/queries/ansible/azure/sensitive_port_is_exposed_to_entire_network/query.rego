package Cx

getFieldName(field) = name {
	upper(field) == "NETWORK PORTS SECURITY"
    name := "azure_rm_securitygroup"
}

getProtocol(resource) = protocol {
	protocol := resource.protocol
}

getProtocolList(protocol) = list {
	protocol == "*"
    list := ["TCP","UDP","Icmp"]
}
else = list {
	upper(protocol) == "TCP"
	list := ["TCP"]
}
else = list {
	upper(protocol) == "UDP"
	list := ["UDP"]
}
else = list {
	upper(protocol) == "ICMP"
	list := ["Icmp"]
}

containsDestinationPort(port, resource) = containing {
	is_string(resource.destination_port_range)
    containing := containsDP(port, resource.destination_port_range)
}
else = containing {
	is_array(resource.destination_port_range)
    containing := containsDP(port, resource.destination_port_range[i])
}

containsDP(port, dpr) = containing {
    regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), dpr)
    containing := true
}
else = containing {
    ports = split(dpr, ",")
    sublist = split(ports[var],"-")
    to_number(trim(sublist[0]," ")) <= port
    to_number(trim(sublist[1]," ")) >= port
    containing := true
}

isAccessibleFromEntireNetwork(resource) = accessible {
	endswith(resource.source_address_prefix, "/0")
    accessible := true
}

isAllowed(resource) = allowed {
	upper(resource.access) == "ALLOW"
    allowed := true
}

isTCPorUDP(protocol) = is {
	is := upper(protocol) != "ICMP"
}


CxPolicy [ result ] {

#############	inputs
    portNumbers :=	[									# List of ports
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
                    [445, "Microsoft-DS"],
                    [636, "LDAP SSL"],
                    [1433, "MSSQL Server"],
                    [1434, "MSSQL Browser"],
                    [2382, "SQL Server Analysis"],
                    [2383, "SQL Server Analysis"],
                    [2484,"Oracle DB SSL"],
                    [3000, "Prevalent known internal port"],
                    [3020, "CIFS / SMB"],
                    [3306, "MySQL"],
                    [3389, "Remote Desktop"],
                    [4506, "SaltStack Master"],
                    [5432, "PostgreSQL"],
                    [5500, "VNC Listener"],
                    [5900, "VNC Server"],
                    [7001, "Cassandra"],
    				[8000, "Known internal web port"],
    				[8080, "Known internal web port"],
                    [8140, "Puppet Master"],
                    [9000, "Hadoop Name Node"],
                    [9090, "CiscoSecure, WebSM"],
                    [11214, "Memcached SSL"],
                    [11215, "Memcached SSL"],
                    [27018, "Mongo Web Portal"],
                    [61621, "Cassandra OpsCenter"]
                    ]

    field := getFieldName("Network Ports Security")		# Category/service used

#############	document and resource
	document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    resource := task[field].rules[r]
    sgName := task.name
    ruleName := resource.name

#############	get relevant fields
	portNumber := portNumbers[j][0]
	portName := portNumbers[j][1]
	protocolList := getProtocolList(getProtocol(resource))
    protocol := protocolList[k]

#############	Checks
	isAllowed(resource)
    isAccessibleFromEntireNetwork(resource)
    containsDestinationPort(portNumber, resource)
    isTCPorUDP(protocol)

#############	Result
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{%s}}.rules.name={{%s}}.destination_port_range", [sgName, field, ruleName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s.%s.rules", [portName, protocol, portNumber, ruleName, field]),
                "keyActualValue":   sprintf("%s (%s:%d) is allowed in %s.%s.rules", [portName, protocol, portNumber, ruleName, field])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
