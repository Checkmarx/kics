package generic.common

import future.keywords.in

# build_search_line will convert all values to string, and build path with given values
# values need to be in the correct order
# obj case is for the walk function although it can be used as needed
# if you already have the complete path and have no need for the obj just pass the obj empty []
# Examples:
# build_search_line(["father", "son", "grandson"], [])
# build_search_line(["father", "son"], ["grandson"])
# [path, value] := walk(doc)
# build_search_line(path, ["grandson"])

build_search_line(path, obj) = resolvedPath {
	resolveArray := [x | pathItem := path[n]; x := convert_path_item(pathItem)]
	resolvedObj := [x | objItem := obj[n]; x := convert_path_item(objItem)]
	resolvedPath = array.concat(resolveArray, resolvedObj)
}

convert_path_item(pathItem) = convertedPath {
	is_number(pathItem)
	convertedPath := sprintf("%d", [pathItem])
} else = convertedPath {
	convertedPath := sprintf("%s", [pathItem])
}

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
	20: "FTP",
	21: "FTP",
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
	443: "HTTPS",
	445: "Microsoft-DS",
	636: "LDAP SSL",
	1433: "MSSQL Server",
	1434: "MSSQL Browser",
	1521: "Oracl DB",
	1522: "Oracle Auto Data Warehouse",
	2375: "Docker",
	2376: "Docker",
	2382: "SQL Server Analysis",
	2383: "SQL Server Analysis",
	2483: "Oracle DB SSL",
	2484: "Oracle DB SSL",
	3000: "Prevalent known internal port",
	3020: "CIFS / SMB",
	3306: "MySQL",
	3389: "Remote Desktop",
	4333: "MySQL",
	4505: "SaltStack Master",
	4506: "SaltStack Master",
	5432: "PostgreSQL",
	5500: "VNC Listener",
	5601: "Kibana",
	5900: "VNC Server",
	5985: "WinRM for HTTP",
	6379: "Redis",
	7000: "Cassandra Internode Communication",
	7001: "Cassandra",
	7199: "Cassandra Monitoring",
	8000: "Known internal web port",
	8020: "HDFS NameNode",
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
	50070: "HDFS NameNode WebUI",
	50470: "HDFS NameNode WebUI",
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

valid_key(obj, key) {
	_ = obj[key]
	not is_null(obj[key])
} else = false {
	true
}

getDays(date, daysInMonth) = days {
	index := date[1] - 2
	index >= 0

	days = ((date[0] * 365) + daysInMonth[index]) + date[2]
}

getDays(date, daysInMonth) = days {
	index := date[1] - 2
	index < 0

	days = (date[0] * 365) + date[2]
}

expired(expirationDate) {
	currentDate := time.date(time.now_ns())
	daysInMonth := [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

	daysInCurrentDate := getDays(currentDate, daysInMonth)
	daysInExpirationDate := getDays(expirationDate, daysInMonth)

	daysInExpirationDate < daysInCurrentDate
}

unsecured_cors_rule(methods, headers, origins) {
	# allows all methods
	availableMethods := {"GET", "PUT", "POST", "DELETE", "HEAD"}
	count({x | method := methods[x]; method == availableMethods[_]}) == count(availableMethods)
} else {
	# allows all headers
	contains(headers[_], "*")
} else {
	# allows several origins
	contains(origins[_], "*")
}

get_module_equivalent_key(provider, moduleName, resource, key) = keyInResource {
	providers := data.common_lib.modules[provider]
	module := providers[moduleName]
	inArray(module.resources, resource)
	keyInResource := module.inputs[key]
}

check_selector(filter, value, op, name) {
	selector := find_selector_by_value(filter, value)
	selector._op == op
	selector._selector == name
} else = false {
	true
}

find_selector_by_value(filter, str) = rtn {
	[_, fvalue] := walk(filter)
	trim(fvalue._value, "\"") == str
	rtn := fvalue
} else {
	[_, fvalue] := walk(filter)
	trim(fvalue._value, "'") == str
	rtn = fvalue
}

get_tag_name_if_exists(resource) = name {
	name := resource.tags.Name
} else = name {
	tag := resource.Properties.Tags[_]
	tag.Key == "Name"
	name := tag.Value
} else = name {
	tag := resource.Properties.FileSystemTags[_]
	tag.Key == "Name"
	name := tag.Value
} else = name {
	tag := resource.Properties.Tags[key]
	key == "Name"
	name := tag
} else = name {
	tag := resource.spec.forProvider.tags[_]
	tag.key == "Name"
	name := tag.value
} else = name {
	tag := resource.properties.tags[key]
	key == "Name"
	name := tag
}


get_encryption_if_exists(resource) = encryption {
	resource.encrypted == true
	encryption := "encrypted"
} else = encryption {
	options := {"encryption_at_rest_kms_key_arn", "encryption_in_transit"}
	valid_key(resource.encryption_info, options[_])
	encryption := "encrypted"
} else = encryption {
	fields := {"sqs_managed_sse_enabled", "kms_master_key_id", "encryption_options", "server_side_encryption_configuration"}
	valid_key(resource, fields[_])
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

engines = {
	"aurora": 3306,
	"aurora-mysql": 3306,
	"aurora-postgresql": 3306,
	"mariadb": 3306,
	"mysql": 3306,
	"oracle-ee": 1521,
	"oracle-ee-cdb": 1521,
	"oracle-se2": 1521,
	"oracle-se2-cdb": 1521,
	"postgres": 5432,
	"sqlserver-ee": 1433,
	"sqlserver-se": 1433,
	"sqlserver-ex": 1433,
	"sqlserver-web": 1433,
}

is_ingress(firewall) {
	not valid_key(firewall, "direction")
} else {
	firewall.direction == "INGRESS"
}

get_statement(policy) = st {
	is_object(policy.Statement)
	st = [policy.Statement]
} else = st {
	is_array(policy.Statement)
	st = policy.Statement
}

is_allow_effect(statement) {
	not valid_key(statement, "Effect")
	not valid_key(statement, "effect")
} else {
	statement.Effect == "Allow"
} else {
    statement.effect == "Allow"
}

get_policy(p) = policy {
	policy = json_unmarshal(p)
} else = policy {
	policy = p
}

is_cross_account(statement) {
	is_string(statement.Principal.AWS)
	regex.match("(^[0-9]{12}$)|(^arn:aws:(iam|sts)::[0-9]{12})", statement.Principal.AWS)
} else {
	is_array(statement.Principal.AWS)
	regex.match("(^[0-9]{12}$)|(^arn:aws:(iam|sts)::[0-9]{12})", statement.Principal.AWS[_])
}

is_assume_role(statement) {
	statement.Action == "sts:AssumeRole"
} else {
	statement.Action[_] == "sts:AssumeRole"
}

has_external_id(statement) {
	count(statement.Condition.StringEquals["sts:ExternalId"]) > 0
}

has_mfa(statement) {
	statement.Condition.BoolIfExists["aws:MultiFactorAuthPresent"] == "true"
} else {
	statement.Condition.Bool["aws:MultiFactorAuthPresent"] == "true"
}

any_principal(statement) {
	contains(statement.Principal, "*")
} else {
	is_string(statement.Principal.AWS)
	contains(statement.Principal.AWS, "*")
} else {
	is_array(statement.Principal.AWS)
	contains(statement.Principal.AWS[_], "*")
} else {
	not valid_key(statement, "Principal")
}

is_recommended_tls(field) {
	inArray({"TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"}, field)
}

is_unrestricted(sourceRange) {
	cidrs := {"0.0.0.0/0", "::/0"}
	sourceRange == cidrs[_]
}

check_principals(statement) {
	statement.principals.identifiers[_] == "*"
	statement.principals.type == "AWS"
} else {
	is_object(statement.Principal) == true
	statement.Principal.AWS == "*"
} else {
	is_string(statement.Principal) == true
	statement.Principal == "*"
}

check_actions(statement, typeAction) {
	any([statement.actions[_] == typeAction, statement.actions[_] == "*"])
} else {
	any([statement.Actions[_] == typeAction, statement.Actions[_] == "*"])
} else {
	is_array(statement.Action) == true
	any([statement.Action[_] == typeAction, statement.Action[_] == "*"])
} else {
	is_string(statement.Action) == true
	any([statement.Action == typeAction, statement.Action == "*"])
}

has_wildcard(statement, typeAction) {
	check_principals(statement)
} else {
	check_actions(statement, typeAction)
}

# valid returns if all array_vals are nested in the object (array_vals should be sorted)
# searchKey returns the searchKey possible
#
# object := {"elem1": {"elem2": "elem3"}}
# array_vals := ["elem1", "elem2", "elem4"]
#
# return_value := {"valid": false, "searchKey": "elem1.elem2"}
get_nested_values_info(object, array_vals) = return_value {
	arr := [x |
		some i, _ in array_vals
		path := array.slice(array_vals, 0, i + 1)
		walk(object, [path, _]) # evaluates to false if path is not in object
		x := path[i]
	]

	return_value := {
		"valid": count(array_vals) == count(arr),
		"searchKey": concat(".", arr),
	}
}

remove_last_point(searchKey) = sk {
	sk := trim_right(searchKey, ".")
}

isOSDir(mountPath) = result {
	hostSensitiveDir = {
		"/bin", "/sbin", "/boot", "/cdrom",
		"/dev", "/etc", "/home", "/lib",
		"/media", "/proc", "/root", "/run",
		"/seLinux", "/srv", "/usr", "/var",
		"/sys",
	}

	result = list_contains(hostSensitiveDir, mountPath)
} else = result {
	result = mountPath == "/"
}

list_contains(dirs, elem) {
	startswith(elem, dirs[_])
}

# if accessibility is "hasPolicy", bom_output should also display the policy content
get_bom_output(bom_output, policy) = output {
	bom_output.resource_accessibility == "hasPolicy"
	out := {"policy": policy}

	output := object.union(bom_output, out)
} else = output {
	output := bom_output
}

# This function is based on these docs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html#describe-ebs-optimization
is_aws_ebs_optimized_by_default(instanceType) {
	inArray(data.common_lib.aws_ebs_optimized_by_default, instanceType)
}

# IANA
weakCipher(aux) {
	weak_ciphers_IANA_Format = {
		"TLS_NULL_WITH_NULL_NULL", "TLS_RSA_WITH_NULL_MD5", "TLS_RSA_WITH_NULL_SHA", "TLS_RSA_EXPORT_WITH_RC4_40_MD5", "TLS_RSA_WITH_RC4_128_MD5", "TLS_RSA_WITH_RC4_128_SHA", "TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5", "TLS_RSA_WITH_IDEA_CBC_SHA", "TLS_RSA_EXPORT_WITH_DES40_CBC_SHA", "TLS_RSA_WITH_DES_CBC_SHA", "TLS_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_DH_DSS_EXPORT_WITH_DES40_CBC_SHA", "TLS_DH_DSS_WITH_DES_CBC_SHA", "TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA", "TLS_DH_RSA_EXPORT_WITH_DES40_CBC_SHA", "TLS_DH_RSA_WITH_DES_CBC_SHA", "TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA", "TLS_DHE_DSS_WITH_DES_CBC_SHA", "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA", "TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA", "TLS_DHE_RSA_WITH_DES_CBC_SHA", "TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_DH_anon_EXPORT_WITH_RC4_40_MD5", "TLS_DH_anon_WITH_RC4_128_MD5", "TLS_DH_anon_EXPORT_WITH_DES40_CBC_SHA", "TLS_DH_anon_WITH_DES_CBC_SHA", "TLS_DH_anon_WITH_3DES_EDE_CBC_SHA", "TLS_KRB5_WITH_DES_CBC_SHA", "TLS_KRB5_WITH_3DES_EDE_CBC_SHA", "TLS_KRB5_WITH_RC4_128_SHA", "TLS_KRB5_WITH_IDEA_CBC_SHA", "TLS_KRB5_WITH_DES_CBC_MD5", "TLS_KRB5_WITH_3DES_EDE_CBC_MD5", "TLS_KRB5_WITH_RC4_128_MD5", "TLS_KRB5_WITH_IDEA_CBC_MD5", "TLS_KRB5_EXPORT_WITH_DES_CBC_40_SHA", "TLS_KRB5_EXPORT_WITH_RC2_CBC_40_SHA", "TLS_KRB5_EXPORT_WITH_RC4_40_SHA", "TLS_KRB5_EXPORT_WITH_DES_CBC_40_MD5", "TLS_KRB5_EXPORT_WITH_RC2_CBC_40_MD5", "TLS_KRB5_EXPORT_WITH_RC4_40_MD5", "TLS_PSK_WITH_NULL_SHA", "TLS_DHE_PSK_WITH_NULL_SHA", "TLS_RSA_PSK_WITH_NULL_SHA", "TLS_RSA_WITH_AES_128_CBC_SHA", "TLS_DH_DSS_WITH_AES_128_CBC_SHA", "TLS_DH_RSA_WITH_AES_128_CBC_SHA", "TLS_DHE_DSS_WITH_AES_128_CBC_SHA", "TLS_DHE_RSA_WITH_AES_128_CBC_SHA", "TLS_DH_anon_WITH_AES_128_CBC_SHA", "TLS_RSA_WITH_AES_256_CBC_SHA", "TLS_DH_DSS_WITH_AES_256_CBC_SHA", "TLS_DH_RSA_WITH_AES_256_CBC_SHA", "TLS_DHE_DSS_WITH_AES_256_CBC_SHA", "TLS_DHE_RSA_WITH_AES_256_CBC_SHA", "TLS_DH_anon_WITH_AES_256_CBC_SHA", "TLS_RSA_WITH_NULL_SHA256", "TLS_RSA_WITH_AES_128_CBC_SHA256", "TLS_RSA_WITH_AES_256_CBC_SHA256", "TLS_DH_DSS_WITH_AES_128_CBC_SHA256", "TLS_DH_RSA_WITH_AES_128_CBC_SHA256", "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256", "TLS_RSA_WITH_CAMELLIA_128_CBC_SHA", "TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA", "TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA", "TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA", "TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA", "TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA", "TLS_DHE_RSA_WITH_AES_128_CBC_SHA256", "TLS_DH_DSS_WITH_AES_256_CBC_SHA256", "TLS_DH_RSA_WITH_AES_256_CBC_SHA256", "TLS_DHE_DSS_WITH_AES_256_CBC_SHA256", "TLS_DHE_RSA_WITH_AES_256_CBC_SHA256", "TLS_DH_anon_WITH_AES_128_CBC_SHA256", "TLS_DH_anon_WITH_AES_256_CBC_SHA256", "TLS_RSA_WITH_CAMELLIA_256_CBC_SHA", "TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA", "TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA", "TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA", "TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA", "TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA", "TLS_PSK_WITH_RC4_128_SHA", "TLS_PSK_WITH_3DES_EDE_CBC_SHA", "TLS_PSK_WITH_AES_128_CBC_SHA", "TLS_PSK_WITH_AES_256_CBC_SHA", "TLS_DHE_PSK_WITH_RC4_128_SHA", "TLS_DHE_PSK_WITH_3DES_EDE_CBC_SHA", "TLS_DHE_PSK_WITH_AES_128_CBC_SHA", "TLS_DHE_PSK_WITH_AES_256_CBC_SHA", "TLS_RSA_PSK_WITH_RC4_128_SHA", "TLS_RSA_PSK_WITH_3DES_EDE_CBC_SHA", "TLS_RSA_PSK_WITH_AES_128_CBC_SHA", "TLS_RSA_PSK_WITH_AES_256_CBC_SHA", "TLS_RSA_WITH_SEED_CBC_SHA", "TLS_DH_DSS_WITH_SEED_CBC_SHA", "TLS_DH_RSA_WITH_SEED_CBC_SHA", "TLS_DHE_DSS_WITH_SEED_CBC_SHA", "TLS_DHE_RSA_WITH_SEED_CBC_SHA", "TLS_DH_anon_WITH_SEED_CBC_SHA", "TLS_RSA_WITH_AES_128_GCM_SHA256", "TLS_RSA_WITH_AES_256_GCM_SHA384", "TLS_DH_RSA_WITH_AES_128_GCM_SHA256", "TLS_DH_RSA_WITH_AES_256_GCM_SHA384", "TLS_DHE_DSS_WITH_AES_128_GCM_SHA256", "TLS_DHE_DSS_WITH_AES_256_GCM_SHA384", "TLS_DH_DSS_WITH_AES_128_GCM_SHA256", "TLS_DH_DSS_WITH_AES_256_GCM_SHA384", "TLS_DH_anon_WITH_AES_128_GCM_SHA256", "TLS_DH_anon_WITH_AES_256_GCM_SHA384", "TLS_PSK_WITH_AES_128_GCM_SHA256", "TLS_PSK_WITH_AES_256_GCM_SHA384", "TLS_RSA_PSK_WITH_AES_128_GCM_SHA256", "TLS_RSA_PSK_WITH_AES_256_GCM_SHA384", "TLS_PSK_WITH_AES_128_CBC_SHA256", "TLS_PSK_WITH_AES_256_CBC_SHA384", "TLS_PSK_WITH_NULL_SHA256", "TLS_PSK_WITH_NULL_SHA384", "TLS_DHE_PSK_WITH_AES_128_CBC_SHA256",
		"TLS_DHE_PSK_WITH_AES_256_CBC_SHA384", "TLS_DHE_PSK_WITH_NULL_SHA256", "TLS_DHE_PSK_WITH_NULL_SHA384", "TLS_RSA_PSK_WITH_AES_128_CBC_SHA256", "TLS_RSA_PSK_WITH_AES_256_CBC_SHA384", "TLS_RSA_PSK_WITH_NULL_SHA256", "TLS_RSA_PSK_WITH_NULL_SHA384", "TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA256", "TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256", "TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA256", "TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA256", "TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA256", "TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256", "TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA256", "TLS_SM4_GCM_SM3", "TLS_SM4_CCM_SM3", "TLS_EMPTY_RENEGOTIATION_INFO_SCSV", "TLS_AES_128_CCM_8_SHA256", "TLS_ECDH_ECDSA_WITH_NULL_SHA", "TLS_ECDH_ECDSA_WITH_RC4_128_SHA", "TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA", "TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA", "TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA", "TLS_ECDHE_ECDSA_WITH_NULL_SHA", "TLS_ECDHE_ECDSA_WITH_RC4_128_SHA", "TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA", "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA", "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA", "TLS_ECDH_RSA_WITH_NULL_SHA", "TLS_ECDH_RSA_WITH_RC4_128_SHA", "TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_ECDH_RSA_WITH_AES_128_CBC_SHA", "TLS_ECDH_RSA_WITH_AES_256_CBC_SHA", "TLS_ECDHE_RSA_WITH_NULL_SHA", "TLS_ECDHE_RSA_WITH_RC4_128_SHA", "TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA", "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA", "TLS_ECDH_anon_WITH_NULL_SHA", "TLS_ECDH_anon_WITH_RC4_128_SHA", "TLS_ECDH_anon_WITH_3DES_EDE_CBC_SHA", "TLS_ECDH_anon_WITH_AES_128_CBC_SHA", "TLS_ECDH_anon_WITH_AES_256_CBC_SHA", "TLS_SRP_SHA_WITH_3DES_EDE_CBC_SHA", "TLS_SRP_SHA_RSA_WITH_3DES_EDE_CBC_SHA", "TLS_SRP_SHA_DSS_WITH_3DES_EDE_CBC_SHA", "TLS_SRP_SHA_WITH_AES_128_CBC_SHA", "TLS_SRP_SHA_RSA_WITH_AES_128_CBC_SHA", "TLS_SRP_SHA_DSS_WITH_AES_128_CBC_SHA", "TLS_SRP_SHA_WITH_AES_256_CBC_SHA", "TLS_SRP_SHA_RSA_WITH_AES_256_CBC_SHA", "TLS_SRP_SHA_DSS_WITH_AES_256_CBC_SHA", "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384", "TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256", "TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384", "TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256", "TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384", "TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256", "TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256", "TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_PSK_WITH_RC4_128_SHA", "TLS_ECDHE_PSK_WITH_3DES_EDE_CBC_SHA", "TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA", "TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA", "TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA384", "TLS_ECDHE_PSK_WITH_NULL_SHA", "TLS_ECDHE_PSK_WITH_NULL_SHA256", "TLS_ECDHE_PSK_WITH_NULL_SHA384", "TLS_RSA_WITH_ARIA_128_CBC_SHA256", "TLS_RSA_WITH_ARIA_256_CBC_SHA384", "TLS_DH_DSS_WITH_ARIA_128_CBC_SHA256", "TLS_DH_DSS_WITH_ARIA_256_CBC_SHA384", "TLS_DH_RSA_WITH_ARIA_128_CBC_SHA256", "TLS_DH_RSA_WITH_ARIA_256_CBC_SHA384", "TLS_DHE_DSS_WITH_ARIA_128_CBC_SHA256", "TLS_DHE_DSS_WITH_ARIA_256_CBC_SHA384", "TLS_DHE_RSA_WITH_ARIA_128_CBC_SHA256", "TLS_DHE_RSA_WITH_ARIA_256_CBC_SHA384", "TLS_DH_anon_WITH_ARIA_128_CBC_SHA256", "TLS_DH_anon_WITH_ARIA_256_CBC_SHA384", "TLS_ECDHE_ECDSA_WITH_ARIA_128_CBC_SHA256", "TLS_ECDHE_ECDSA_WITH_ARIA_256_CBC_SHA384", "TLS_ECDH_ECDSA_WITH_ARIA_128_CBC_SHA256", "TLS_ECDH_ECDSA_WITH_ARIA_256_CBC_SHA384", "TLS_ECDHE_RSA_WITH_ARIA_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_ARIA_256_CBC_SHA384", "TLS_ECDH_RSA_WITH_ARIA_128_CBC_SHA256", "TLS_ECDH_RSA_WITH_ARIA_256_CBC_SHA384", "TLS_RSA_WITH_ARIA_128_GCM_SHA256", "TLS_RSA_WITH_ARIA_256_GCM_SHA384", "TLS_DHE_RSA_WITH_ARIA_128_GCM_SHA256", "TLS_DHE_RSA_WITH_ARIA_256_GCM_SHA384", "TLS_DH_RSA_WITH_ARIA_128_GCM_SHA256", "TLS_DH_RSA_WITH_ARIA_256_GCM_SHA384", "TLS_DHE_DSS_WITH_ARIA_128_GCM_SHA256", "TLS_DHE_DSS_WITH_ARIA_256_GCM_SHA384", "TLS_DH_DSS_WITH_ARIA_128_GCM_SHA256", "TLS_DH_DSS_WITH_ARIA_256_GCM_SHA384", "TLS_DH_anon_WITH_ARIA_128_GCM_SHA256",
		"TLS_DH_anon_WITH_ARIA_256_GCM_SHA384", "TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256", "TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384", "TLS_ECDH_ECDSA_WITH_ARIA_128_GCM_SHA256", "TLS_ECDH_ECDSA_WITH_ARIA_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384", "TLS_ECDH_RSA_WITH_ARIA_128_GCM_SHA256", "TLS_ECDH_RSA_WITH_ARIA_256_GCM_SHA384", "TLS_PSK_WITH_ARIA_128_CBC_SHA256", "TLS_PSK_WITH_ARIA_256_CBC_SHA384", "TLS_DHE_PSK_WITH_ARIA_128_CBC_SHA256", "TLS_DHE_PSK_WITH_ARIA_256_CBC_SHA384", "TLS_RSA_PSK_WITH_ARIA_128_CBC_SHA256", "TLS_RSA_PSK_WITH_ARIA_256_CBC_SHA384", "TLS_PSK_WITH_ARIA_128_GCM_SHA256", "TLS_PSK_WITH_ARIA_256_GCM_SHA384", "TLS_DHE_PSK_WITH_ARIA_128_GCM_SHA256", "TLS_DHE_PSK_WITH_ARIA_256_GCM_SHA384", "TLS_RSA_PSK_WITH_ARIA_128_GCM_SHA256", "TLS_RSA_PSK_WITH_ARIA_256_GCM_SHA384", "TLS_ECDHE_PSK_WITH_ARIA_128_CBC_SHA256", "TLS_ECDHE_PSK_WITH_ARIA_256_CBC_SHA384", "TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_CBC_SHA384", "TLS_ECDH_ECDSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_ECDH_ECDSA_WITH_CAMELLIA_256_CBC_SHA384", "TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384", "TLS_ECDH_RSA_WITH_CAMELLIA_128_CBC_SHA256", "TLS_ECDH_RSA_WITH_CAMELLIA_256_CBC_SHA384", "TLS_RSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_RSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DH_RSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DH_RSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DHE_DSS_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DHE_DSS_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DH_DSS_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DH_DSS_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DH_anon_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DH_anon_WITH_CAMELLIA_256_GCM_SHA384", "TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_ECDH_ECDSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_ECDH_ECDSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_ECDH_RSA_WITH_CAMELLIA_128_GCM_SHA256", "TLS_ECDH_RSA_WITH_CAMELLIA_256_GCM_SHA384", "TLS_PSK_WITH_CAMELLIA_128_GCM_SHA256", "TLS_PSK_WITH_CAMELLIA_256_GCM_SHA384", "TLS_DHE_PSK_WITH_CAMELLIA_128_GCM_SHA256", "TLS_DHE_PSK_WITH_CAMELLIA_256_GCM_SHA384", "TLS_RSA_PSK_WITH_CAMELLIA_128_GCM_SHA256", "TLS_RSA_PSK_WITH_CAMELLIA_256_GCM_SHA384", "TLS_PSK_WITH_CAMELLIA_128_CBC_SHA256", "TLS_PSK_WITH_CAMELLIA_256_CBC_SHA384", "TLS_DHE_PSK_WITH_CAMELLIA_128_CBC_SHA256", "TLS_DHE_PSK_WITH_CAMELLIA_256_CBC_SHA384", "TLS_RSA_PSK_WITH_CAMELLIA_128_CBC_SHA256", "TLS_RSA_PSK_WITH_CAMELLIA_256_CBC_SHA384", "TLS_ECDHE_PSK_WITH_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_PSK_WITH_CAMELLIA_256_CBC_SHA384", "TLS_RSA_WITH_AES_128_CCM", "TLS_RSA_WITH_AES_256_CCM", "TLS_RSA_WITH_AES_128_CCM_8", "TLS_RSA_WITH_AES_256_CCM_8", "TLS_DHE_RSA_WITH_AES_128_CCM_8", "TLS_DHE_RSA_WITH_AES_256_CCM_8", "TLS_PSK_WITH_AES_128_CCM", "TLS_PSK_WITH_AES_256_CCM", "TLS_PSK_WITH_AES_128_CCM_8", "TLS_PSK_WITH_AES_256_CCM_8", "TLS_PSK_DHE_WITH_AES_128_CCM_8", "TLS_PSK_DHE_WITH_AES_256_CCM_8", "TLS_ECDHE_ECDSA_WITH_AES_128_CCM", "TLS_ECDHE_ECDSA_WITH_AES_256_CCM", "TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8", "TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8", "TLS_ECCPWD_WITH_AES_128_GCM_SHA256", "TLS_ECCPWD_WITH_AES_256_GCM_SHA384", "TLS_ECCPWD_WITH_AES_128_CCM_SHA256", "TLS_ECCPWD_WITH_AES_256_CCM_SHA384", "TLS_SHA256_SHA256", "TLS_SHA384_SHA384", "TLS_GOSTR341112_256_WITH_KUZNYECHIK_CTR_OMAC", "TLS_GOSTR341112_256_WITH_MAGMA_CTR_OMAC", "TLS_GOSTR341112_256_WITH_28147_CNT_IMIT", "TLS_GOSTR341112_256_WITH_KUZNYECHIK_MGM_L", "TLS_GOSTR341112_256_WITH_MAGMA_MGM_L", "TLS_GOSTR341112_256_WITH_KUZNYECHIK_MGM_S", "TLS_GOSTR341112_256_WITH_MAGMA_MGM_S", "TLS_PSK_WITH_CHACHA20_POLY1305_SHA256", "TLS_RSA_PSK_WITH_CHACHA20_POLY1305_SHA256", "TLS_ECDHE_PSK_WITH_AES_128_CCM_8_SHA256",
	}
	weak_ciphers_IANA_Format[_] == aux
}

# OpenSSL
weakCipher(aux) {
	weak_ciphers_OpenSSL_Format = {"NULL-MD5", "NULL-SHA", "IDEA-CBC-SHA", "DES-CBC3-SHA", "DHE-DSS-DES-CBC3-SHA", "DHE-RSA-DES-CBC3-SHA", "ADH-DES-CBC3-SHA", "PSK-NULL-SHA", "DHE-PSK-NULL-SHA", "RSA-PSK-NULL-SHA", "AES128-SHA", "DHE-DSS-AES128-SHA", "DHE-RSA-AES128-SHA", "ADH-AES128-SHA", "AES256-SHA", "DHE-DSS-AES256-SHA", "DHE-RSA-AES256-SHA", "ADH-AES256-SHA", "NULL-SHA256", "AES128-SHA256", "AES256-SHA256", "DHE-DSS-AES128-SHA256", "CAMELLIA128-SHA", "DHE-DSS-CAMELLIA128-SHA", "DHE-RSA-CAMELLIA128-SHA", "ADH-CAMELLIA128-SHA", "DHE-RSA-AES128-SHA256", "DHE-DSS-AES256-SHA256", "DHE-RSA-AES256-SHA256", "ADH-AES128-SHA256", "ADH-AES256-SHA256", "CAMELLIA256-SHA", "DHE-DSS-CAMELLIA256-SHA", "DHE-RSA-CAMELLIA256-SHA", "ADH-CAMELLIA256-SHA", "PSK-3DES-EDE-CBC-SHA", "PSK-AES128-CBC-SHA", "PSK-AES256-CBC-SHA", "DHE-PSK-3DES-EDE-CBC-SHA", "DHE-PSK-AES128-CBC-SHA", "DHE-PSK-AES256-CBC-SHA", "RSA-PSK-3DES-EDE-CBC-SHA", "RSA-PSK-AES128-CBC-SHA", "RSA-PSK-AES256-CBC-SHA", "SEED-SHA", "DHE-DSS-SEED-SHA", "DHE-RSA-SEED-SHA", "ADH-SEED-SHA", "AES128-GCM-SHA256", "AES256-GCM-SHA384", "DHE-DSS-AES128-GCM-SHA256", "DHE-DSS-AES256-GCM-SHA384", "ADH-AES128-GCM-SHA256", "ADH-AES256-GCM-SHA384", "PSK-AES128-GCM-SHA256", "PSK-AES256-GCM-SHA384", "RSA-PSK-AES128-GCM-SHA256", "RSA-PSK-AES256-GCM-SHA384", "PSK-AES128-CBC-SHA256", "PSK-AES256-CBC-SHA384", "PSK-NULL-SHA256", "PSK-NULL-SHA384", "DHE-PSK-AES128-CBC-SHA256", "DHE-PSK-AES256-CBC-SHA384", "DHE-PSK-NULL-SHA256", "DHE-PSK-NULL-SHA384", "RSA-PSK-AES128-CBC-SHA256", "RSA-PSK-AES256-CBC-SHA384", "RSA-PSK-NULL-SHA256", "RSA-PSK-NULL-SHA384", "CAMELLIA128-SHA256", "DHE-DSS-CAMELLIA128-SHA256", "DHE-RSA-CAMELLIA128-SHA256", "ADH-CAMELLIA128-SHA256", "CAMELLIA256-SHA256", "DHE-DSS-CAMELLIA256-SHA256", "DHE-RSA-CAMELLIA256-SHA256", "ADH-CAMELLIA256-SHA256", "ECDHE-ECDSA-NULL-SHA", "ECDHE-ECDSA-DES-CBC3-SHA", "ECDHE-ECDSA-AES128-SHA", "ECDHE-ECDSA-AES256-SHA", "ECDHE-RSA-NULL-SHA", "ECDHE-RSA-DES-CBC3-SHA", "ECDHE-RSA-AES128-SHA", "ECDHE-RSA-AES256-SHA", "AECDH-NULL-SHA", "AECDH-DES-CBC3-SHA", "AECDH-AES128-SHA", "AECDH-AES256-SHA", "SRP-3DES-EDE-CBC-SHA", "SRP-RSA-3DES-EDE-CBC-SHA", "SRP-DSS-3DES-EDE-CBC-SHA", "SRP-AES-128-CBC-SHA", "SRP-RSA-AES-128-CBC-SHA", "SRP-DSS-AES-128-CBC-SHA", "SRP-AES-256-CBC-SHA", "SRP-RSA-AES-256-CBC-SHA", "SRP-DSS-AES-256-CBC-SHA", "ECDHE-ECDSA-AES128-SHA256", "ECDHE-ECDSA-AES256-SHA384", "ECDHE-RSA-AES128-SHA256", "ECDHE-RSA-AES256-SHA384", "ECDHE-PSK-3DES-EDE-CBC-SHA", "ECDHE-PSK-AES128-CBC-SHA", "ECDHE-PSK-AES256-CBC-SHA", "ECDHE-PSK-AES128-CBC-SHA256", "ECDHE-PSK-AES256-CBC-SHA384", "ECDHE-PSK-NULL-SHA", "ECDHE-PSK-NULL-SHA256", "ECDHE-PSK-NULL-SHA384", "ECDHE-ECDSA-CAMELLIA128-SHA256", "ECDHE-ECDSA-CAMELLIA256-SHA384", "ECDHE-RSA-CAMELLIA128-SHA256", "ECDHE-RSA-CAMELLIA256-SHA384", "PSK-CAMELLIA128-SHA256", "PSK-CAMELLIA256-SHA384", "DHE-PSK-CAMELLIA128-SHA256", "DHE-PSK-CAMELLIA256-SHA384", "RSA-PSK-CAMELLIA128-SHA256", "RSA-PSK-CAMELLIA256-SHA384", "ECDHE-PSK-CAMELLIA128-SHA256", "ECDHE-PSK-CAMELLIA256-SHA384", "AES128-CCM", "AES256-CCM", "AES128-CCM8", "AES256-CCM8", "DHE-RSA-AES128-CCM8", "DHE-RSA-AES256-CCM8", "PSK-AES128-CCM", "PSK-AES256-CCM", "PSK-AES128-CCM8", "PSK-AES256-CCM8", "DHE-PSK-AES128-CCM8", "DHE-PSK-AES256-CCM8", "ECDHE-ECDSA-AES128-CCM", "ECDHE-ECDSA-AES256-CCM", "ECDHE-ECDSA-AES128-CCM8", "ECDHE-ECDSA-AES256-CCM8", "PSK-CHACHA20-POLY1305", "RSA-PSK-CHACHA20-POLY1305"}
	weak_ciphers_OpenSSL_Format[_] == aux
}

# GnuTLS
weakCipher(aux) {
	weak_ciphers_GnuTLS_Format = {"TLS_RSA_NULL_MD5", "TLS_RSA_NULL_SHA1", "TLS_RSA_ARCFOUR_128_MD5", "TLS_RSA_ARCFOUR_128_SHA1", "TLS_RSA_3DES_EDE_CBC_SHA1", "TLS_DHE_DSS_3DES_EDE_CBC_SHA1", "TLS_DHE_RSA_3DES_EDE_CBC_SHA1", "TLS_DH_ANON_ARCFOUR_128_MD5", "TLS_DH_ANON_3DES_EDE_CBC_SHA1", "TLS_PSK_NULL_SHA1", "TLS_DHE_PSK_NULL_SHA1", "TLS_RSA_PSK_NULL_SHA1", "TLS_RSA_AES_128_CBC_SHA1", "TLS_DHE_DSS_AES_128_CBC_SHA1", "TLS_DHE_RSA_AES_128_CBC_SHA1", "TLS_DH_ANON_AES_128_CBC_SHA1", "TLS_RSA_AES_256_CBC_SHA1", "TLS_DHE_DSS_AES_256_CBC_SHA1", "TLS_DHE_RSA_AES_256_CBC_SHA1", "TLS_DH_ANON_AES_256_CBC_SHA1", "TLS_RSA_NULL_SHA256", "TLS_RSA_AES_128_CBC_SHA256", "TLS_RSA_AES_256_CBC_SHA256", "TLS_DHE_DSS_AES_128_CBC_SHA256", "TLS_RSA_CAMELLIA_128_CBC_SHA1", "TLS_DHE_DSS_CAMELLIA_128_CBC_SHA1", "TLS_DHE_RSA_CAMELLIA_128_CBC_SHA1", "TLS_DH_ANON_CAMELLIA_128_CBC_SHA1", "TLS_DHE_RSA_AES_128_CBC_SHA256", "TLS_DHE_DSS_AES_256_CBC_SHA256", "TLS_DHE_RSA_AES_256_CBC_SHA256", "TLS_DH_ANON_AES_128_CBC_SHA256", "TLS_DH_ANON_AES_256_CBC_SHA256", "TLS_RSA_CAMELLIA_256_CBC_SHA1", "TLS_DHE_DSS_CAMELLIA_256_CBC_SHA1", "TLS_DHE_RSA_CAMELLIA_256_CBC_SHA1", "TLS_DH_ANON_CAMELLIA_256_CBC_SHA1", "TLS_PSK_ARCFOUR_128_SHA1", "TLS_PSK_3DES_EDE_CBC_SHA1", "TLS_PSK_AES_128_CBC_SHA1", "TLS_PSK_AES_256_CBC_SHA1", "TLS_DHE_PSK_ARCFOUR_128_SHA1", "TLS_DHE_PSK_3DES_EDE_CBC_SHA1", "TLS_DHE_PSK_AES_128_CBC_SHA1", "TLS_DHE_PSK_AES_256_CBC_SHA1", "TLS_RSA_PSK_ARCFOUR_128_SHA1", "TLS_RSA_PSK_3DES_EDE_CBC_SHA1", "TLS_RSA_PSK_AES_128_CBC_SHA1", "TLS_RSA_PSK_AES_256_CBC_SHA1", "TLS_RSA_AES_128_GCM_SHA256", "TLS_RSA_AES_256_GCM_SHA384", "TLS_DHE_DSS_AES_128_GCM_SHA256", "TLS_DHE_DSS_AES_256_GCM_SHA384", "TLS_DH_ANON_AES_128_GCM_SHA256", "TLS_DH_ANON_AES_256_GCM_SHA384", "TLS_PSK_AES_128_GCM_SHA256", "TLS_PSK_AES_256_GCM_SHA384", "TLS_RSA_PSK_AES_128_GCM_SHA256", "TLS_RSA_PSK_AES_256_GCM_SHA384", "TLS_PSK_AES_128_CBC_SHA256", "TLS_PSK_AES_256_CBC_SHA384", "TLS_PSK_NULL_SHA256", "TLS_PSK_NULL_SHA384", "TLS_DHE_PSK_AES_128_CBC_SHA256", "TLS_DHE_PSK_AES_256_CBC_SHA384", "TLS_DHE_PSK_NULL_SHA256", "TLS_DHE_PSK_NULL_SHA384", "TLS_RSA_PSK_AES_128_CBC_SHA256", "TLS_RSA_PSK_AES_256_CBC_SHA384", "TLS_RSA_PSK_NULL_SHA256", "TLS_RSA_PSK_NULL_SHA384", "TLS_RSA_CAMELLIA_128_CBC_SHA256", "TLS_DHE_DSS_CAMELLIA_128_CBC_SHA256", "TLS_DHE_RSA_CAMELLIA_128_CBC_SHA256", "TLS_DH_ANON_CAMELLIA_128_CBC_SHA256", "TLS_RSA_CAMELLIA_256_CBC_SHA256", "TLS_DHE_DSS_CAMELLIA_256_CBC_SHA256", "TLS_DHE_RSA_CAMELLIA_256_CBC_SHA256", "TLS_DH_ANON_CAMELLIA_256_CBC_SHA256", "TLS_ECDHE_ECDSA_NULL_SHA1", "TLS_ECDHE_ECDSA_ARCFOUR_128_SHA1", "TLS_ECDHE_ECDSA_3DES_EDE_CBC_SHA1", "TLS_ECDHE_ECDSA_AES_128_CBC_SHA1", "TLS_ECDHE_ECDSA_AES_256_CBC_SHA1", "TLS_ECDHE_RSA_NULL_SHA1", "TLS_ECDHE_RSA_ARCFOUR_128_SHA1", "TLS_ECDHE_RSA_3DES_EDE_CBC_SHA1", "TLS_ECDHE_RSA_AES_128_CBC_SHA1", "TLS_ECDHE_RSA_AES_256_CBC_SHA1", "TLS_ECDH_ANON_NULL_SHA1", "TLS_ECDH_ANON_ARCFOUR_128_SHA1", "TLS_ECDH_ANON_3DES_EDE_CBC_SHA1", "TLS_ECDH_ANON_AES_128_CBC_SHA1", "TLS_ECDH_ANON_AES_256_CBC_SHA1", "TLS_SRP_SHA_3DES_EDE_CBC_SHA1", "TLS_SRP_SHA_RSA_3DES_EDE_CBC_SHA1", "TLS_SRP_SHA_DSS_3DES_EDE_CBC_SHA1", "TLS_SRP_SHA_AES_128_CBC_SHA1", "TLS_SRP_SHA_RSA_AES_128_CBC_SHA1", "TLS_SRP_SHA_DSS_AES_128_CBC_SHA1", "TLS_SRP_SHA_AES_256_CBC_SHA1", "TLS_SRP_SHA_RSA_AES_256_CBC_SHA1", "TLS_SRP_SHA_DSS_AES_256_CBC_SHA1", "TLS_ECDHE_ECDSA_AES_128_CBC_SHA256", "TLS_ECDHE_ECDSA_AES_256_CBC_SHA384", "TLS_ECDHE_RSA_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_AES_256_CBC_SHA384", "TLS_ECDHE_PSK_ARCFOUR_128_SHA1", "TLS_ECDHE_PSK_3DES_EDE_CBC_SHA1", "TLS_ECDHE_PSK_AES_128_CBC_SHA1", "TLS_ECDHE_PSK_AES_256_CBC_SHA1", "TLS_ECDHE_PSK_AES_128_CBC_SHA256", "TLS_ECDHE_PSK_AES_256_CBC_SHA384", "TLS_ECDHE_PSK_NULL_SHA1", "TLS_ECDHE_PSK_NULL_SHA256", "TLS_ECDHE_PSK_NULL_SHA384", "TLS_ECDHE_ECDSA_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_ECDSA_CAMELLIA_256_CBC_SHA384", "TLS_ECDHE_RSA_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_RSA_CAMELLIA_256_CBC_SHA384", "TLS_RSA_CAMELLIA_128_GCM_SHA256", "TLS_RSA_CAMELLIA_256_GCM_SHA384", "TLS_DHE_RSA_CAMELLIA_128_GCM_SHA256", "TLS_DHE_RSA_CAMELLIA_256_GCM_SHA384", "TLS_DHE_DSS_CAMELLIA_128_GCM_SHA256", "TLS_DHE_DSS_CAMELLIA_256_GCM_SHA384", "TLS_DH_ANON_CAMELLIA_128_GCM_SHA256", "TLS_DH_ANON_CAMELLIA_256_GCM_SHA384", "TLS_ECDHE_ECDSA_CAMELLIA_128_GCM_SHA256", "TLS_ECDHE_ECDSA_CAMELLIA_256_GCM_SHA384", "TLS_ECDHE_RSA_CAMELLIA_128_GCM_SHA256", "TLS_ECDHE_RSA_CAMELLIA_256_GCM_SHA384", "TLS_PSK_CAMELLIA_128_GCM_SHA256", "TLS_PSK_CAMELLIA_256_GCM_SHA384", "TLS_DHE_PSK_CAMELLIA_128_GCM_SHA256", "TLS_DHE_PSK_CAMELLIA_256_GCM_SHA384", "TLS_RSA_PSK_CAMELLIA_128_GCM_SHA256", "TLS_RSA_PSK_CAMELLIA_256_GCM_SHA384", "TLS_PSK_CAMELLIA_128_CBC_SHA256", "TLS_PSK_CAMELLIA_256_CBC_SHA384", "TLS_DHE_PSK_CAMELLIA_128_CBC_SHA256", "TLS_DHE_PSK_CAMELLIA_256_CBC_SHA384", "TLS_RSA_PSK_CAMELLIA_128_CBC_SHA256", "TLS_RSA_PSK_CAMELLIA_256_CBC_SHA384", "TLS_ECDHE_PSK_CAMELLIA_128_CBC_SHA256", "TLS_ECDHE_PSK_CAMELLIA_256_CBC_SHA384", "TLS_RSA_AES_128_CCM", "TLS_RSA_AES_256_CCM", "TLS_RSA_AES_128_CCM_8", "TLS_RSA_AES_256_CCM_8", "TLS_DHE_RSA_AES_128_CCM_8", "TLS_DHE_RSA_AES_256_CCM_8", "TLS_PSK_AES_128_CCM", "TLS_PSK_AES_256_CCM", "TLS_PSK_AES_128_CCM_8", "TLS_PSK_AES_256_CCM_8", "TLS_DHE_PSK_AES_128_CCM_8", "TLS_DHE_PSK_AES_256_CCM_8", "TLS_ECDHE_ECDSA_AES_128_CCM", "TLS_ECDHE_ECDSA_AES_256_CCM", "TLS_ECDHE_ECDSA_AES_128_CCM_8", "TLS_ECDHE_ECDSA_AES_256_CCM_8", "TLS_PSK_CHACHA20_POLY1305", "TLS_RSA_PSK_CHACHA20_POLY1305"}
	weak_ciphers_GnuTLS_Format[_] == aux
}


#aurora is equivelent to mysql 5.6 https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/UsingWithRDS.IAMDBAuth.html#UsingWithRDS.IAMDBAuth.Availability
#all aurora-postgresql versions that do not support IAM auth are deprecated Source:console.aws (launch rds instance)
valid_for_iam_engine_and_version_check(resource, engineVar, engineVersionVar, instanceClassVar) {
	key_list := [engineVar, engineVersionVar]
	contains(lower(resource[engineVar]), "mariadb")
	supported_versions := {"10.6", "10.11", "11.4"}
	version_check := {x | x := resource[key_list[_]]; contains(x, supported_versions[_])}
	count(version_check) > 0
} else {
	engines_that_supports_iam := ["aurora-postgresql", "postgres", "mysql", "mariadb"]
	contains(lower(resource[engineVar]), engines_that_supports_iam[_])
	not valid_key(resource, engineVersionVar)
} else {
	engines_that_supports_iam := ["aurora-postgresql", "postgres", "mysql"]
	contains(lower(resource[engineVar]), engines_that_supports_iam[_])
} else {
	aurora_mysql_engines := ["aurora", "aurora-mysql"]
	contains(lower(resource[engineVar]), aurora_mysql_engines[_])
	invalid_classes := ["db.t2.small", "db.t3.small"]
	not inArray(invalid_classes, resource[instanceClassVar])
}

get_group_from_policy_attachment(attachment) = group {
	group := split(attachment.groups[_], ".")[1]
} else = group {
	group := split(attachment.group, ".")[1]
}

get_role_from_policy_attachment(attachment) = role {
	role := split(attachment.roles[_], ".")[1]
} else = role {
	role := split(attachment.role, ".")[1]
}

get_user_from_policy_attachment(attachment) = user {
	user := split(attachment.users[_], ".")[1]
} else = user {
	user := split(attachment.user, ".")[1]
}

unrecommended_permission_policy(resourcePolicy, permission) {
	policy := json_unmarshal(resourcePolicy.policy)

	st := get_statement(policy)
	statement := st[_]

	is_allow_effect(statement)

	equalsOrInArray(statement.Resource, "*")
	equalsOrInArray(statement.Action, lower(permission))
}

group_unrecommended_permission_policy_scenarios(targetGroup, permission) {
	# get the IAM group policy
	groupPolicy := input.document[_].resource.aws_iam_group_policy[_]

	# get the group referenced in IAM group policy and confirm it is the target group
	group := split(groupPolicy.group, ".")[1]
	group == targetGroup

	# verify that the policy is unrecommended
	unrecommended_permission_policy(groupPolicy, permission)
} else {
	# find attachment
	attachments := {"aws_iam_policy_attachment", "aws_iam_group_policy_attachment"}
	attachment := input.document[_].resource[attachments[_]][_]

	# get the group referenced in IAM policy attachment and confirm it is the target group
	group := get_group_from_policy_attachment(attachment)
	group == targetGroup

	# confirm that policy associated is unrecommended
	policy := split(attachment.policy_arn, ".")[1]

	policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	resourcePolicy := input.document[_].resource[policies[_]][policy]

	# verify that the policy is unrecommended
	unrecommended_permission_policy(resourcePolicy, permission)
}

role_unrecommended_permission_policy_scenarios(targetRole, permission) {
	# get the IAM role policy
	rolePolicy := input.document[_].resource.aws_iam_role_policy[_]

	# get the role referenced in IAM role policy and confirm it is the target role
	role := split(rolePolicy.role, ".")[1]
	role == targetRole

	# verify that the policy is unrecommended
	unrecommended_permission_policy(rolePolicy, permission)
} else {
	# find attachment
	attachments := {"aws_iam_policy_attachment", "aws_iam_role_policy_attachment"}
	attachment := input.document[_].resource[attachments[_]][_]

	# get the role referenced in IAM policy attachment and confirm it is the target role
	role := get_role_from_policy_attachment(attachment)
	role == targetRole

	# confirm that policy associated is unrecommended
	policy := split(attachment.policy_arn, ".")[1]

	policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	resourcePolicy := input.document[_].resource[policies[_]][policy]

	# verify that the policy is unrecommended
	unrecommended_permission_policy(resourcePolicy, permission)
}

user_unrecommended_permission_policy_scenarios(targetUser, permission) {
	# get the IAM user policy
	userPolicy := input.document[_].resource.aws_iam_user_policy[_]

	# get the user referenced in IAM user policy and confirm it is the target user
	user := split(userPolicy.user, ".")[1]
	user == targetUser

	# verify that the policy is unrecommended
	unrecommended_permission_policy(userPolicy, permission)
} else {
	# find attachment
	attachments := {"aws_iam_policy_attachment", "aws_iam_user_policy_attachment"}
	attachment := input.document[_].resource[attachments[_]][_]

	# get the user referenced in IAM policy attachment and confirm it is the target user
	user := get_user_from_policy_attachment(attachment)
	user == targetUser

	# confirm that policy associated is unrecommended
	policy := split(attachment.policy_arn, ".")[1]

	policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	resourcePolicy := input.document[_].resource[policies[_]][policy]

	# verify that the policy is unrecommended
	unrecommended_permission_policy(resourcePolicy, permission)
}

get_latest_software_version(name) = version {
	software_info := data.version_numbers_to_check
	software_info[i].name == name
	version := software_info[i].version
}

get_version(name) = version {
	val := get_latest_software_version(name)
	splited := split(val, ".")
	version := concat(".", [splited[0],splited[1]])
}

contains_element(arr, element) {
    element == arr[_]
}

contains_with_size(arr, element){
	count(arr)>0
    test := arr[j]
	contains(test, element)
}

valid_non_empty_key(field, key) = output {
	not valid_key(field, key)
	output = ""
} else = output {
	keyObj := field[key]
	is_object(keyObj)
	count(keyObj) == 0
	output := concat(".", ["", key])
} else = output {
	keyObj := field[key]
	keyObj == ""
	output := concat(".", ["", key])
}
