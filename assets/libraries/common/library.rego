package generic.common

###### Get Line By json structure ###################
## For Helm searchLine is unused
get_search_line(obj, key, idx) = line {
	idx < 0
	line = get_line(obj, key, idx)
} else = line {
	idx >= 0
	line = get_arr_line(obj, parse_key(key), idx)
} else = -1 {
	true
}

get_line(obj, key, idx) = line {
	key == ""
	line = obj._kics_lines._kics__default._kics_line
} else = line {
	line = obj._kics_lines[sprintf("_kics_%s", [key[0]])]._kics_line
}

get_arr_line(obj, key, idx) = line {
	key[1] == ""
	line = obj._kics_lines[sprintf("_kics_%s", [key[0]])]._kics_arr[idx]._kics__default._kics_line
} else = line {
	line = obj._kics_lines[sprintf("_kics_%s", [key[0]])]._kics_arr[idx][sprintf("_kics_%s", [key[1]])]._kics_line
}

parse_key(key) = key_name {
	count(key) == 1
	key_name := [key[0], ""]
} else = key {
	true
}

################################################################

concat_path(path) = concatenated {
	concatenated := concat(".", [x | x := resolve_path(path[_]); x != ""])
}

resolve_path(pathItem) = resolved {
	any([contains(pathItem, "."), contains(pathItem, "="), contains(pathItem, "/")])
	resolved := sprintf("{{%s}}", [pathItem])
} else = resolved {
	is_number(pathItem)
	resolved := ""
} else = pathItem {
	true
}

json_unmarshal(s) = result {
	s == null
	result := json.unmarshal("{}")
}

json_unmarshal(s) = result {
	s != null
	result := json.unmarshal(s)
}

calc_IP_value(ip) = result {
	ips := split(ip, ".")

	#calculate the value of an ip
	#a.b.c.d
	#a*16777216 + b*65536 + c*256 + d
	result = (((to_number(ips[0]) * 16777216) + (to_number(ips[1]) * 65536)) + (to_number(ips[2]) * 256)) + to_number(ips[3])
}

# Checks if a value is within a range
between(value, min, max) {
	value >= min
	value <= max
}

# Checks if a list contains an item
inArray(list, item) {
	some i
	list[i] == item
}

# Checks if a value is empty ("") or null
emptyOrNull("") = true

emptyOrNull(null) = true

# Checks if an IP is private
isPrivateIP(ipVal) {
	private_ips := ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	some i
	net.cidr_contains(private_ips[i], ipVal)
}

# Checks if an object is empty ignoring kics lines
check_obj_empty(obj) {
	obj = null
} else {
	count({x | o := obj[n]; n != "_kics_lines"; x = o}) == 0
}

# Check if field equals to value or if any element from field equals to value
equalsOrInArray(field, value) {
	is_string(field)
	lower(field) == value
}

equalsOrInArray(field, value) {
	is_array(field)
	some i
	lower(field[i]) == value
}

# Check if field contains value or if any element from field contains value
containsOrInArrayContains(field, value) {
	is_string(value)
	contains(lower(field), value)
}

containsOrInArrayContains(field, value) {
	is_array(field)
	some i
	contains(lower(field[i]), value)
}

isDefaultPassword(p) {
	ar = {
		"!@",
		"root",
		"wubao",
		"password",
		"123456",
		"admin",
		"12345",
		"1234",
		"p@ssw0rd",
		"123",
		"1",
		"jiamima",
		"test",
		"root123",
		"!",
		"!q@w",
		"!qaz@wsx",
		"idc!@",
		"admin!@",
		"",
		"alpine",
		"qwerty",
		"12345678",
		"111111",
		"123456789",
		"1q2w3e4r",
		"123123",
		"default",
		"1234567",
		"qwe123",
		"1qaz2wsx",
		"1234567890",
		"abcd1234",
		"000000",
		"user",
		"toor",
		"qwer1234",
		"1q2w3e",
		"asdf1234",
		"redhat",
		"1234qwer",
		"cisco",
		"12qwaszx",
		"test123",
		"1q2w3e4r5t",
		"admin123",
		"changeme",
		"1qazxsw2",
		"123qweasd",
		"q1w2e3r4",
		"letmein",
		"server",
		"root1234",
		"master",
		"abc123",
		"rootroot",
		"a",
		"system",
		"pass",
		"1qaz2wsx3edc",
		"p@$$w0rd",
		"112233",
		"welcome",
		"!QAZ2wsx",
		"linux",
		"123321",
		"manager",
		"1qazXSW@",
		"q1w2e3r4t5",
		"oracle",
		"asd123",
		"admin123456",
		"ubnt",
		"123qwe",
		"qazwsxedc",
		"administrator",
		"superuser",
		"zaq12wsx",
		"121212",
		"654321",
		"ubuntu",
		"0000",
		"zxcvbnm",
		"root@123",
		"1111",
		"vmware",
		"q1w2e3",
		"qwerty123",
		"cisco123",
		"11111111",
		"pa55w0rd",
		"asdfgh",
		"11111",
		"123abc",
		"asdf",
		"centos",
		"888888",
		"54321",
		"password123",
		"pa$$",
	}

	ar[p]
}

isCommonValue(p) {
	bl = {
		"RESOURCE",
		"GROUP",
		"SUBNET",
		"S3",
		"SERVICE",
		"AZURE",
		"BUCKET",
		"VIRTUAL",
		"NETWORK",
		"POLICY",
		"AWS",
		"PROTOCOL",
		"CLOUD",
		"MINUTE",
		"TLS",
		"EC2",
		"VPC",
		"INTERNET",
		"ROUTE",
		"EFS",
		"INSTANCE",
		"VPN",
		"MOUNT",
		"MYSQL",
		"APACHE",
		"ETHERNET",
		"TERRAFORM",
		"TARGET",
		"ENVIRONMENT",
		"MEMORY",
		"PACKAGE",
		"STATEMENT",
		"REGION",
		"INGRESS",
		"CHECKPOINT",
		"MODULE",
		"BASIC",
		"NUMBER",
		"MASLEN",
		"VERSION",
		"MAKE",
		"ARCH",
	}

	black := bl[_]
	contains(upper(p), black)
}

isCommonKey(p) {
	bl = {
		"namespace",
		"bypass",
		"name",
		"ref",
		"base64",
		"pattern",
		"author",
		"group",
		"image",
		"host",
		"interface",
		"service",
		"src",
		"value",
		"default",
		"sku",
		"condition",
		"status",
		"size",
		"runtime",
		"id",
		"chdir",
		"env",
		"person",
		"kind",
		"content",
		"age",
		"length",
		"prevention",
		"change",
		"attribute",
		"stage",
		"version",
		"tag",
		"alert",
		"device",
		"type",
		"java",
		"metadata",
		"child",
		"sc1",
		"task",
		"memory",
		"storage",
		"bundle",
		"label",
		"origin",
		"upstream",
		"time",
		"project",
		"from",
		"maven",
		"destination",
		"shape",
		"local",
		"target",
		"exported",
		"zone",
		"description",
		"folder",
		"lc_all",
		"lang",
		"path",
		"arch",
		"location",
	}

	black := bl[_]
	contains(lower(p), black)
}

# Dictionary of TCP ports
tcpPortsMap = {
	22: "SSH",
	23: "Telnet",
	25: "SMTP",
	53: "DNS",
	80: "HTTP",
	110: "POP3",
	135: "MSSQL Debugger",
	137: "NetBIOS Name Service",
	138: "NetBIOS Datagram Service",
	139: "NetBIOS Session Service",
	161: "SNMP",
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
	5985: "WinRM for HTTP",
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
	9090: "CiscoSecure, WebSM",
	9160: "Cassandra Thrift",
	9200: "Elastic Search",
	9300: "Elastic Search",
	11211: "Memcached",
	11214: "Memcached SSL",
	11215: "Memcached SSL",
	27017: "Mongo",
	27018: "Mongo Web Portal",
	61620: "Cassandra OpsCenter",
	61621: "Cassandra OpsCenter",
}

# verifies if the resource(statement.Principal.AWS) contains an ARN that points to a specific IAM user
allowsAllPrincipalsToAssume(resource, statement) {
	is_string(resource) == true
	contains(resource, "arn:aws:iam::")
	contains(resource, ":root")
	not contains(statement.Effect, "Deny")
}

allowsAllPrincipalsToAssume(resource, statement) {
	is_array(resource) == true
	contains(resource[x], "arn:aws:iam::")
	contains(resource[x], ":root")
	not contains(statement.Effect, "Deny")
}

compareArrays(arrayOne, arrayTwo) {
	upper(arrayOne[_]) == upper(arrayTwo[_])
} else = false {
	true
}
