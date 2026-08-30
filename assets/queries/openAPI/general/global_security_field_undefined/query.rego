package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

# IMPROVED VERSION: Reduces False Positives by checking if path-level security is properly implemented
CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	
	# Only flag if BOTH conditions are true:
	# 1. No global security field
	# 2. AND there are paths without operation-level security
	not common_lib.valid_key(doc, "security")
	has_unsecured_paths(doc)
	
	searchKey := {
		"3.0": "openapi",
		"2.0": "swagger",
	}

	result := {
		"documentId": doc.id,
		"searchKey": searchKey[version],
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security property should be defined or all paths should have operation-level security",
		"keyActualValue": "A default security property is not defined and there are unsecured paths",
		"overrideKey": version,
	}
}

# Helper function: Check if there are paths without security
has_unsecured_paths(doc) {
	path := doc.paths[pathName]
	operation := path[operationName]
	
	# Check if this operation is a valid HTTP method
	is_http_method(operationName)
	
	# This operation has no security defined
	not common_lib.valid_key(operation, "security")
	
	# AND it's not explicitly marked as having no security (empty array)
	not is_explicitly_unsecured(operation)
}

# Helper function: Check if operation is explicitly marked as unsecured
is_explicitly_unsecured(operation) {
	operation.security == []
}

# Helper function: Validate HTTP methods
is_http_method(method) {
	http_methods := ["get", "post", "put", "patch", "delete", "head", "options", "trace"]
	lower(method) == http_methods[_]
}
