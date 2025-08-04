package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

instances := {"AWS::EC2::Instance", "AWS::EC2::LaunchTemplate"}

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.Resources[name]
    resource.Type == instances[_]

    is_metadata_service_enabled(resource)

    res := http_tokens_undefined_or_not_required(resource.Properties, name)

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"], 
		"searchLine": res["sl"],
	}
}

is_metadata_service_enabled (resource) {
    resource.Properties.MetadataOptions.HttpEndpoint == "enabled"
} else {
    not common_lib.valid_key(resource.Properties, "MetadataOptions")
} else {
    not common_lib.valid_key(resource.Properties.MetadataOptions, "HttpEndpoint")
}

http_tokens_undefined_or_not_required(resource_properties, name) = res {
    not common_lib.valid_key(resource_properties, "MetadataOptions")
    res := {
        "kev": sprintf("'Resources.%s.Properties.MetadataOptions' should  be defined with 'HttpTokens' field set to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.MetadataOptions' is not defined", [name]),
        "sk": sprintf("Resources.%s.Propeties", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties"], []),
        "it": "MissingAttribute",
    }
} else = res { 
    common_lib.valid_key(resource_properties, "MetadataOptions") 
    not common_lib.valid_key(resource_properties.MetadataOptions, "HttpTokens")

    res := {
        "kev": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' should be defined to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' is not defined", [name]),
        "sk": sprintf("Resources.%s.Properties.MetadataOptions", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "MetadataOptions"], []),
        "it": "MissingAttribute"
    }
} else = res { 
    common_lib.valid_key(resource.MetadataOptions, "HttpTokens")
    not resource_properties.MetadataOptions.HttpTokens == "required"

    res := {
        "kev": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' should be defined to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' is not defined to 'required'", [name]),
        "sk": sprintf("Resources.%s.Properties.MetadataOptions.HttpTokens", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "MetadataOptions", "HttpTokens"], []),
        "it": "IncorrectValue"
    }
}