package Cx

import data.generic.common as common_lib

# Improved rule: Only flags variables that actually need documentation
# based on complexity, sensitivity, or validation rules

CxPolicy[result] {
	variable := input.document[i].variable[variableName]
	not common_lib.valid_key(variable, "description")
	
	# Only flag variables that actually need documentation
	needs_description(variable, variableName)

	result := {
		"documentId": input.document[i].id,
	    "resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Complex or sensitive variable '%s' should have a description", [variableName]),
		"keyActualValue": "'description' is undefined or null",
	}
}

CxPolicy[result] {
	description := input.document[i].variable[variableName].description
	count(trim(description, " ")) == 0
	
	variable := input.document[i].variable[variableName]
	# Only flag variables that actually need documentation
	needs_description(variable, variableName)

	result := {
		"documentId": input.document[i].id,
	    "resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}.description", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Complex or sensitive variable '%s' should have a non-empty description", [variableName]),
		"keyActualValue": "'description' is empty",
	}
}

# Determine if a variable needs documentation based on complexity and context
needs_description(variable, variableName) {
	# Always flag sensitive variables
	variable.sensitive == true
} else {
	# Flag variables with validation rules
	common_lib.valid_key(variable, "validation")
} else {
	# Flag complex types (objects, maps, lists of objects, sets)
	is_complex_type(variable)
} else {
	# Flag long or non-obvious variable names that aren't self-explanatory
	not is_self_explanatory(variableName)
	not is_short_and_simple(variableName)
}

# Check if variable has a complex type that warrants documentation
is_complex_type(variable) {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	# Object types
	contains(type_str, "object(")
} else {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	# Maps of objects
	contains(type_str, "map(object(")
} else {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	# Lists of objects
	contains(type_str, "list(object(")
} else {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	# Sets
	contains(type_str, "set(")
}

# Check if variable name is self-explanatory
is_self_explanatory(variableName) {
	# Common, obvious variable names
	obvious_names := {
		"region", "environment", "env", "name", "port", "version",
		"tags", "vpc_id", "subnet_id", "key", "value", "enabled"
	}
	lower(variableName) == obvious_names[_]
} else {
	# Variables with clear suffixes
	clear_suffixes := {"_name", "_id", "_arn", "_url", "_enabled", "_count", "_size"}
	endswith(lower(variableName), clear_suffixes[_])
} else {
	# Variables with clear prefixes
	clear_prefixes := {"enable_", "disable_", "is_", "has_", "use_", "allow_"}
	startswith(lower(variableName), clear_prefixes[_])
}

# Check if variable name is short and simple enough to not need description
is_short_and_simple(variableName) {
	# Very short variables (8 chars or less)
	count(variableName) <= 8
	not contains(variableName, "_")  # Single word
} else {
	# Single words up to 12 characters
	count(variableName) <= 12
	not contains(variableName, "_")  # Single word
}
