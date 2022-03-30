package generic.cloudformation

import data.generic.common as common_lib

isCloudFormationFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
# Find out if the document has a resource type equals to 'AWS::SecretsManager::Secret'
hasSecretManager(str, document) {
	selectedSecret := strings.replace_n({"${": "", "}": ""}, regex.find_n(`\${\w+}`, str, 1)[0])
	document[selectedSecret].Type == "AWS::SecretsManager::Secret"
}

# Check if the type is ELB
isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
}

# Check if the type is ELB
isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
}

# Check if there is an action inside an array
checkAction(currentAction, actionToCompare) {
	is_string(currentAction)
    currentAction == "*"
    currentAction == actionToCompare
} else {
    is_string(currentAction)
	contains(lower(currentAction), actionToCompare)
} else {
    is_array(currentAction)
    action := currentAction[_]
    action == "*"
    action == actionToCompare
} else {
    is_array(currentAction)
    action := currentAction[_]
    contains(lower(action), actionToCompare)
}

# Dictionary of UDP ports
udpPortsMap = {
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
    11215: "Memcached SSL",
}

# Get content of the resource(s) based on the type
getResourcesByType(resources, type) = list {
    list = [resource | resources[i].Type == type; resource := resources[i]]
}

getBucketName(resource) = name {
	name := resource.Properties.Bucket
    not common_lib.valid_key(name, "Ref")
} else = name {
	name := resource.Properties.Bucket.Ref
}

get_encryption(resource) = encryption {
	resource.Properties.Encrypted == true
    encryption := "encrypted"
} else = encryption {
    fields := {"KmsMasterKeyId", "EncryptionInfo", "EncryptionOptions", "BucketEncryption"}
    common_lib.valid_key(resource.Properties, fields[_])
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

get_name(targetName) = name {
	common_lib.valid_key(targetName, "Ref")
	name := targetName.Ref
} else = name {
	not common_lib.valid_key(targetName, "Ref")
	name := targetName
}

get_resource_accessibility(nameRef, type, key) = info {
	document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
    document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}
