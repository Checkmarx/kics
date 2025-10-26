package Cx

import data.generic.common as common_lib

# Check for missing or empty descriptions, but allow simple obvious variable names
CxPolicy[result] {
	variable := input.document[i].variable[variableName]
	not common_lib.valid_key(variable, "description")
	
	# Don't flag extremely common/obvious variable names (INFO severity - low priority)
	not is_extremely_obvious_variable_name(variableName)

	result := {
		"documentId": input.document[i].id,
	    "resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}", [variableName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'description' should be defined and not null",
		"keyActualValue": "'description' is undefined or null",
	}
}

CxPolicy[result] {
	description := input.document[i].variable[variableName].description
	count(trim(description, " ")) == 0
	
	# Don't flag extremely common/obvious variable names
	not is_extremely_obvious_variable_name(variableName)

	result := {
		"documentId": input.document[i].id,
	    "resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("variable.{{%s}}.description", [variableName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'description' should not be empty",
		"keyActualValue": "'description' is empty",
	}
}

# Extremely obvious variable names that don't need descriptions
is_extremely_obvious_variable_name(name) {
	obvious := {
		"region", "environment", "env", "zone", "enabled", "enable", "disabled", "disable",
		"port", "count", "size", "id", "key", "name", "value", "tag", "tags",
		"app", "application", "tier", "role", "type", "stage", "phase"
	}
	lower(name) == obvious[_]
}

is_extremely_obvious_variable_name(name) {
	# Very common compound names (but not domain-specific like "cluster_name")
	common_compounds := {
		"instance_count", "database_name", "api_key", "enable_logging", 
		"is_production", "use_ssl"
	}
	lower(name) == common_compounds[_]
}

is_extremely_obvious_variable_name(name) {
	# Very common prefixes
	prefixes := {"enable_", "disable_", "is_", "use_"}
	startswith(lower(name), prefixes[_])
}

# Helper function: Determine if a variable actually needs a description
needs_description(variable, variableName) {
	# Variables with validation rules ALWAYS need descriptions
	common_lib.valid_key(variable, "validation")
}

needs_description(variable, variableName) {
	# Sensitive variables ALWAYS need descriptions for security documentation
	variable.sensitive == true
}

needs_description(variable, variableName) {
	# Flag complex variables that definitely need documentation
	has_complex_characteristics(variable, variableName)
	
	# But exclude simple, self-explanatory cases
	not is_self_explanatory(variableName)
}

# Helper function: Check if variable has complex characteristics requiring documentation
has_complex_characteristics(variable, variableName) {
	# Complex type (object, map with multiple keys, etc.)
	is_complex_type(variable)
}

has_complex_characteristics(variable, variableName) {
	# Has validation rules - indicates complexity
	common_lib.valid_key(variable, "validation")
}

has_complex_characteristics(variable, variableName) {
	# Has sensitive flag - security-related variables should be documented
	variable.sensitive == true
}

has_complex_characteristics(variable, variableName) {
	# No default value and complex name - likely needs explanation
	not common_lib.valid_key(variable, "default")
	not is_simple_name(variableName)
}

# Helper function: Check if variable type is complex
is_complex_type(variable) {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	
	# Check for complex types
	contains(type_str, "object(")
}

is_complex_type(variable) {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	
	# Check for maps with multiple keys or lists of objects
	contains(type_str, "map(object(")
}

is_complex_type(variable) {
	common_lib.valid_key(variable, "type")
	type_str := sprintf("%v", [variable.type])
	
	# Check for sets of complex types
	contains(type_str, "set(object(")
}

# Helper function: Check if variable name is simple
is_simple_name(variableName) {
	count(variableName) <= 15  # Short names are often simple
	not contains(variableName, "_config")
	not contains(variableName, "_settings")
}

# Helper function: Check if variable name is self-explanatory
is_self_explanatory(variableName) {
	# Common, obvious variable names
	obvious_names := {
		"name", "region", "environment", "env", "zone", "enabled", "enable", 
		"disabled", "disable", "count", "size", "port", "protocol", "version",
		"id", "key", "value", "tag", "tags", "label", "labels", "namespace",
		"project", "app", "application", "service", "component", "tier",
		"stage", "phase", "role", "type", "kind", "category", "group",
		"owner", "team", "department", "organization", "org", "company",
		"domain", "subdomain", "host", "hostname", "endpoint", "url", "uri",
		"path", "directory", "folder", "file", "filename", "extension",
		"prefix", "suffix", "separator", "delimiter", "format", "encoding",
		"timeout", "interval", "duration", "period", "frequency", "rate",
		"limit", "max", "min", "threshold", "capacity", "quota", "budget"
	}
	
	# Check exact match
	lower(variableName) == obvious_names[_]
}

is_self_explanatory(variableName) {
	# Variables ending with obvious suffixes
	obvious_suffixes := {"_name", "_id", "_key", "_port", "_size", "_count", "_enabled", "_disabled"}
	endswith(lower(variableName), obvious_suffixes[_])
}

is_self_explanatory(variableName) {
	# Variables starting with obvious prefixes
	obvious_prefixes := {"enable_", "disable_", "is_", "has_", "use_", "allow_", "deny_"}
	startswith(lower(variableName), obvious_prefixes[_])
}
