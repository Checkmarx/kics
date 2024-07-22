package generic.azureresourcemanager

# gets the network security group properties for two types of resource ('Microsoft.Network/networkSecurityGroups' and 'Microsoft.Network/networkSecurityGroups/securityRules')
get_sg_info(value) = typeInfo {
    value.type == "Microsoft.Network/networkSecurityGroups/securityRules"
	typeInfo := {
		"type": value.type, 
		"properties": value.properties, 
		"path": "resources.type={{Microsoft.Network/networkSecurityGroups/securityRules}}.properties",
		"sl": ["properties"]
   }   
} else = typeInfo {
	value.type == "securityRules"
	typeInfo := {
		"type": value.type, 
		"properties": value.properties, 
		"path": "resources.type={{securityRules}}.properties",
		"sl": ["properties"]
	}
}

# checks if source address prefix is open to the Internet
relevantSourceAddPrefix := {"*", "0.0.0.0", "internet", "any"}

source_address_prefix_is_open(properties) {
	properties.sourceAddressPrefix == relevantSourceAddPrefix[p]
} else {
	endswith(properties.sourceAddressPrefix, "/0")
} else {
	properties.sourceAddressPrefixes[x] == relevantSourceAddPrefix[p]
} else {
	endswith(properties.sourceAddressPrefixes[x], "/0")
}

contains_target_port(targetPort, port) {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [targetPort]), port)
} else {
	ports = split(port, ",")
	sublist = split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= targetPort
	to_number(trim(sublist[1], " ")) >= targetPort
} else {
	port == "*"
}

contains_port(properties, targetPort) {
	contains_target_port(targetPort, properties.destinationPortRange)
} else {
	contains_target_port(targetPort, properties.destinationPortRanges[d])
}

# get_children returns an Array of all children of the resource
# doc is input.document[i]
# parent is the parent resource
get_children(doc, parent, path) = childArr {
	resourceArr := [x | x := {"value": parent.resources[_], "path": array.concat(path, ["resources"])}]
	outerArr := get_outer_children(doc, parent.name)
	childArr := array.concat(resourceArr, outerArr)
}

get_outer_children(doc, nameParent) = outerArr {
	outerArr := [x |
		[path, value] := walk(doc)
		startswith(value.name, nameParent)
		value.name != nameParent
		x := {"value": value, "path": path}
	]
}

getDefaultValueFromParametersIfPresent(doc, valueToCheck) = [value, propertyType] {
	parameterName := isParameterReference(valueToCheck)
	parameter := doc.parameters[parameterName].defaultValue
	value := parameter
	propertyType := "parameter default value"
} else = [value, propertyType] {
	not isParameterReference(valueToCheck)
	value := valueToCheck
	propertyType := "property value"
}

isParameterReference(valueToCheck) = parameterName {
	startswith(valueToCheck, "[parameters('")
	endswith(valueToCheck, "')]")
	parameterName := trim_right(trim_left(trim_left(valueToCheck, "[parameters"), "('"), "')]")
}


isDisabledOrUndefined(doc, resource, parametersPath){
	object.get(resource, split(parametersPath, "."), "not defined") == "not defined"
} else {
	value := object.get(resource, split(parametersPath, "."),"")
	[check, _] := getDefaultValueFromParametersIfPresent(doc, value)
	check == false
}
