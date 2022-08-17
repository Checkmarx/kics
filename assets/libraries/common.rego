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
	[fpath, fvalue] := walk(filter)
	trim(fvalue._value, "\"") == str
	rtn := fvalue
} else {
	[fpath, fvalue] := walk(filter)
	trim(fvalue._value, "'") == str
	rtn := fvalue
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
} else {
	statement.Effect == "Allow"
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
		path := array.slice(array_vals, 0, i+1)
		walk(object, [path, _]) # evaluates to false if path is not in object
		x := path[i]
	]

	return_value := {
		"valid": count(array_vals) == count(arr),
		"searchKey": concat(".", arr)
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
