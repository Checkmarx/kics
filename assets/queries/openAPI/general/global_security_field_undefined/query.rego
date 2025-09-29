package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

# Improved rule: Only flags if BOTH conditions are true:
# 1. No global security field AND
# 2. There are paths without operation-level security
CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	not common_lib.valid_key(doc, "security")
	
	# Check if there are paths without operation-level security
	has_unsecured_operations(doc)
	
	searchKey := {
		"3.0": "openapi",
		"2.0": "swagger",
	}

	result := {
		"documentId": doc.id,
		"searchKey": searchKey[version],
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security property should be defined when there are operations without operation-level security",
		"keyActualValue": "A default security property is not defined and there are operations without operation-level security",
		"overrideKey": version,
	}
}

# Helper function to check if there are operations without security
has_unsecured_operations(doc) {
	paths := doc.paths
	path := paths[_]
	operation := path[method]
	is_valid_http_method(method)
	not has_operation_security(operation)
}

# Check if an operation has security defined
has_operation_security(operation) {
	common_lib.valid_key(operation, "security")
} else {
	# Handle explicit no-security case (security: [])
	operation.security == []
}

# Validate HTTP methods to avoid flagging parameters or extensions
is_valid_http_method(method) {
	valid_methods := {"get", "post", "put", "delete", "options", "head", "patch", "trace"}
	lower(method) == valid_methods[_]
}
