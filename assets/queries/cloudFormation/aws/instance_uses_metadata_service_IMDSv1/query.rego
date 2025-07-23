package Cx

import data.generic.common as common_lib
import data.generic.cloudFormation as cf_lib

instances := {"AWS::EC2::Instance", "AWS::EC2::LaunchTemplate"}

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.Resources[name]
    resource.Type == instances[_]

    properties := resource.Properties

    common_lib.valid_key(properties, "MetadataOptions")
    common_lib.valid_key(properties.MetadataOptions, "HttpEndpoint")
    not properties.MetadataOptions.HttpEndpoint == "enabled"

    result := {
		"documentId": input.document[i].id,
		"resourceType": "",#resource.Type,
		"resourceName": "",#cf_lib.get_resource_name(resource, name),
		"searchKey": "",#sprintf("Resources.%s.Properties.%s", [name, sgs[s]]),
		"issueType": "",
		"keyExpectedValue": "",#sprintf("'Resources.%s.Properties.%s' should not be using default security group", [name, sgs[s]]),
		"keyActualValue": "", #sprintf("'Resources.%s.Properties.%s' is using default security group", [name, sgs[s]]),
		"searchLine": "", #common_lib.build_search_line(["Resources", name, "Properties", sgs[s]], [idx]),
	}
}

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.Resources[name]
    resource.Type == instances[_]

    res := http_tokens_undefined_or_not_required(resource.Properties, name)

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": res["sk"],#sprintf("Resources.%s.Properties.%s", [name, sgs[s]]),
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],#sprintf("'Resources.%s.Properties.%s' should not be using default security group", [name, sgs[s]]),
		"keyActualValue": res["kav"], #sprintf("'Resources.%s.Properties.%s' is using default security group", [name, sgs[s]]),
		"searchLine": res["sl"], #common_lib.build_search_line(["Resources", name, "Properties", sgs[s]], [idx]),
	}
}

http_tokens_undefined_or_not_required(resource_properties, name) = res {
    not common_lib.valid_key(resource_properties, "MetadataOptions") # MetadataOptions field not defined
    res := {
        "kev": "",
        "kav": "",
        "sk": "",
        "sl": "",
        "it": "MissingAttribute",
    }
} else = res { # MetadataOptions.HttpTokens field not defined -> será vulnerabilidade no caso de cf ?
    common_lib.valid_key(resource_properties, "MetadataOptions") 
    not common_lib.valid_key(resource_properties.MetadataOptions, "HttpTokens")

    res := {
        "kev": "",
        "kav": "",
        "sk": "",
        "sl": "",
        "it": "MissingAttribute"
    }
} else = res { # MetadataOptions.HttpTokens defined but not to 'required'
    common_lib.valid_key(resource.MetadataOptions, "HttpTokens")
    not resource_properties.MetadataOptions.HttpTokens == "required"

    res := {
        "kev": "",
        "kav": "",
        "sk": "",
        "sl": "",
        "it": "IncorrectValue"
    }
}