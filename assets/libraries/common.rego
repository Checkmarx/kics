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

# Matches a value against a list of patterns
# and returns set of unique verdicts in form of boolean values
get_match_verdicts(value, patterns) = match_verdicts{
   match_verdicts := {regex.match(pattern, value) | pattern := normalize_to_list(patterns)[_]}
}

# Returns final verdict as boolean values.
# Returns true if there is atleast one match of value in a given set of patterns
has_atleast_one_match(value, patterns) = true {
	match_verdicts := get_match_verdicts(value, patterns)
    match_verdicts[true]
}


# Converts AWS' wild card to regular regex pattern for futher evaluations
aws_wc_to_re(string, not_flag) = re_pat{
    not_flag == false
	re_pat := replace(replace(string, "*",".*"),"?",".")
}


# Normalizes a value to list
# Useful as Principal, Action etc can contain both string and array of string type
normalize_to_list(values) = values{
    is_array(values)
} else = val{
    is_string(values)
    val:= split(values, ",")
} else = val{
    not is_array(values)
    not is_string(values)
    val := [values]
}

# Converts a value to list of regex patterns
convert_value_to_regex(statement, field) = value{
    values := statement[field]
	value = [aws_wc_to_re(v, false) | v := normalize_to_list(values)[_]]
} else = value{
    field_value = object.get(statement, field,"empty")
    field_value == "empty"
	value = []
}

# Principal is a little complex object which can have sub-fields such as AWS, Service unlike
# resource and action which can have only string or array of strings. This method normalizes
# the Principal and NotPrincipal fields in regex compatible policy
handle_principle_regex(statement, principal_field) = regex_compatible_principals{
	principal := object.get(statement, principal_field, [])
    principal != []
    not is_object(principal)
    regex_compatible_principals = convert_value_to_regex(statement, principal_field)
} else =  regex_compatible_principals{
	principal := object.get(statement, principal_field, [])
    principal != []
    is_object(principal)
    available_keys = [key | _ = principal[key]]
    # The below statement creates an array of individual objects looking something like below
    # [{"aws": ["asd.*"]}, {"service": ["lambda.amazonaws.com"]}]
    # Couldn't find a way to dynamically update an object hence relying on list comprehension.
    # There needs to be a better way to return it as single object than this off beat array format.
    regex_compatible_principals = [{lower(key): convert_value_to_regex(principal, key)} | key := available_keys[_]]
} else = regex_compatible_principals{
	principal := object.get(statement, principal_field, [])
    principal == []
    regex_compatible_principals = []
}

# Returns normalized regex compatible policy statement
normalize_statement(statement) = ps {
	ps = {
         "principal": handle_principle_regex(statement, "Principal"),
         "not_principal": handle_principle_regex(statement, "NotPrincipal"),
         "effect": statement.Effect,
         "action": convert_value_to_regex(statement, "Action"),
         "not_action": convert_value_to_regex(statement, "NotAction"),
         "resource": convert_value_to_regex(statement, "Resource"),
         "not_resource": convert_value_to_regex(statement, "NotResource"),
         # Condition is not normalized as other fields since it is technically not feasible to
         # evaluate in a declarative fashion. The consumer may have to manually evaluate the
         # condition based on the context of a control
         "condition": object.get(statement, "Condition", []),
         "sid": object.get(statement, "Sid", "")
          }
}

# Parses policy statements to regex based policy
make_regex_compatible_policy_statement(policy_statements) = regex_compatible_statements {
	regex_compatible_statements := [normalize_statement(statement) | statement := normalize_to_list(policy_statements)[_]]
}

# This method helps in evaluating if an action matches in a statement.
# In case true is returned , it just means that this action is affected by this statement.
# One has to explicitly check whether it is allowed / denied
statement_matches_action(statement, action) {
	object.get(statement, "not_action", []) != []
    not has_atleast_one_match(action, object.get(statement, "not_action", []))
} else {
	object.get(statement, "action", []) != []
    has_atleast_one_match(action, object.get(statement, "action", []))
}

# This method helps in evaluating if a resource matches in a statement.
# In case true is returned , it just means that this resource's access is affected by this statement.
# One has to explicitly check whether it is allowed / denied.
statement_matches_resource(statement, resource) {
	object.get(statement, "not_resource", []) != []
    not has_atleast_one_match(resource, object.get(statement, "not_resource", []))
} else {
	object.get(statement, "resource", []) != []
    has_atleast_one_match(resource, object.get(statement, "resource", []))
}

# This method helps in evaluating if a principal matches in a statement.
# In case true is returned , it just means that this principal's access is affected by this statement.
# One has to explicitly check whether it is allowed / denied.
statement_matches_principal(statement, principal, principal_type) {
	not_principal_object := object.get(statement, "not_principal", "empty")
    is_object(not_principal_object)
    patterns := not_principal_object[_][lower(principal_type)]
    not has_atleast_one_match(principal, patterns)
} else {
	principal_object := object.get(statement, "principal", "empty")
    is_object(principal_object)
    patterns:= principal_object[_][lower(principal_type)]
    has_atleast_one_match(principal, patterns)
} else {
	principal_type == ""
    not_principal_object := object.get(statement, "not_principal", "empty")
    is_array(not_principal_object)
    patterns = not_principal_object
    not has_atleast_one_match(principal, patterns)
} else {
	principal_type == ""
    principal_object := object.get(statement, "principal", "empty")
    is_array(principal_object)
    patterns = principal_object
    has_atleast_one_match(principal, patterns)
}

# Checks whether statement has conditions
statement_has_condition(statement) {
	statement.condition != []
}


# Checks if statement allows or denies
statement_allows(statement) {
	statement.effect == "Allow"
}

# Check Sid
statement_matches_sid(statement, pattern) {
	has_atleast_one_match(statement.sid, pattern)
}

# Checks whether statement explicitly denies action
# This does not consider context of denial such as if action is denied only
# on any specific resource.
# This only considers action and effect.
statement_explicitly_denies_action(statement, action) {
	# If a policy has a condition field, then it signifies that it is a conditional denial and not
    # absolute denial which also means there exists a scope for denial to not apply for a provided context.
	# Hence it is reasonable to not consider it for all general purposes.
    not statement_has_condition(statement)
    not statement_allows(statement)
    statement_matches_action(statement, action)
}

# Checks whether statement explicitly allows action
# This does not consider context of allowance such as if action is allowed only
# on any specific resource.
# This only considers action and effect.
statement_explicitly_allows_action(statement, action) {
    statement_allows(statement)
    statement_matches_action(statement, action)
}

# Checks whether statement explicitly is denied on a resource
# This does not consider context of denial such as if resource is denied only
# on any specifc case.
# This only considers resource and effect.
statement_explicitly_denies_resource(statement, resource) {
	# If a policy has a condition field, then it signifies that it is a conditional denial and not
    # absolute denial which also means there exists a scope for denial to not apply for a provided context.
	# Hence it is reasonable to not consider it for all general purposes.
    not statement_has_condition(statement)
    not statement_allows(statement)
    statement_matches_resource(statement, resource)
}

# Checks whether statement explicitly is allowed on a resource
# This does not consider context of allowance such as if resource is allowed only
# on any specifc case.
# This only considers resource and effect.
statement_explicitly_allows_resource(statement, resource) {
    statement_allows(statement)
    statement_matches_action(statement, resource)
}

statement_explicitly_denies_principal(statement, principal, principal_type) {
	# If a policy has a condition field, then it signifies that it is a conditional denial and not
    # absolute denial which also means there exists a scope for denial to not apply for a provided context.
	# Hence it is reasonable to not consider it for all general purposes.
    not statement_has_condition(statement)
    not statement_allows(statement)
    statement_matches_principal(statement, principal, principal_type)
}

statement_explicitly_allows_principal(statement, principal, principal_type) {
    statement_allows(statement)
    statement_matches_principal(statement, principal, principal_type)
}

# Does policy allow an action
# The method assumes the context of resource and principal is same across all statements in a given policy
# This only considers action and affect.
policy_allows_action(statements, action) {
    explicit_denial_verdicts := {statement_explicitly_denies_action(s, action) | s := statements[_]}
    not explicit_denial_verdicts[true]
    explicit_allowed_verdicts := {statement_explicitly_allows_action(s, action) | s := statements[_]}
    explicit_allowed_verdicts[true]
}


has_highly_permissive_principal(policy_statement){
	policy_statement.principal[_] == ".*"
    statement_allows(policy_statement)
} else {
	# A statement with NotPrincipal and with a non wild card value is
    # practically equivalent of allowing world leaving a reasonably most probable small subset. Hence this stance.
	policy_statement.not_principal[_] != ".*"
    statement_allows(policy_statement)
} else {
	policy_statement.principal[_].aws[_] == ".*"
    statement_allows(policy_statement)
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

