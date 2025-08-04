package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "clientCertEnabled") 

	res := is_using_http2_protocol(value, "null")
	not res["ret_val"] 
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]), 
		"issueType": "MissingAttribute",
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": common_lib.build_search_line(path, ["properties"]), 
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.clientCertEnabled) 
	val == false

	res := is_using_http2_protocol(value, val_type)
	not res["ret_val"]
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.clientCertEnabled", [common_lib.concat_path(path), value.name]), 
		"issueType": "IncorrectValue",
		"keyExpectedValue": res["kev"], 
		"keyActualValue": res["kav"],
		"searchLine": common_lib.build_search_line(path, ["properties", "clientCertEnabled"]), 
	}
}

is_using_http2_protocol(resource, val_type) = res { # clientCertEnabled and http20Enabled field's set to false
	not val_type == "null"
    http20Enabled_field_value := extract_http20Enabled_field_value(resource)
    not http20Enabled_field_value
    res := {
    	"ret_val": false,
        "kev": sprintf("resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' %s or 'http20Enabled' field set to true", [val_type]),
        "kav": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' or 'http20Enabled' set to true",
    }
} else = res { # clientCertEnabled field set to false and non defined http20Enabled field
    not val_type == "null"
    not http20Enabled_field_is_defined(resource)
    res := {
    	"ret_val": false,
        "kev": sprintf("resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' %s set to true", [val_type]),
        "kav": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' set to true",
    }
} else = res { # clientCertEnabled field not defined and http20Enabled field defined 
	val_type == "null"
    http20Enabled_field_is_defined(resource)
    res := {
    	"ret_val": resource.properties.siteConfig.http20Enabled,
        "kev": "resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' property defined",
        "kav": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' property defined",
    }
} else = res { # clientCertEnabled and http20Enabled field's not defined
	val_type == "null"
    not http20Enabled_field_is_defined(resource)
    res := {
    	"ret_val": false,
        "kev": "resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' property defined",
        "kav": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' property defined",
    }
} 

extract_http20Enabled_field_value(resource) = val {
	http20Enabled_field_is_defined(resource)
    val := resource.properties.siteConfig.http20Enabled
} 

http20Enabled_field_is_defined(resource) {
	common_lib.valid_key(resource, "properties") 
    common_lib.valid_key(resource.properties, "siteConfig") 
    common_lib.valid_key(resource.properties.siteConfig, "http20Enabled") 
}