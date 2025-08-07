package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.Resources[name]
    resource.Type == "AWS::EC2::Instance"

    is_metadata_service_enabled(resource.Properties)

    res := http_tokens_undefined_or_not_required_instance(resource.Properties, name)

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

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.Resources[name]
    resource.Type == "AWS::EC2::LaunchTemplate"

    is_metadata_service_enabled(resource.Properties.LaunchTemplateData)

    res := http_tokens_undefined_or_not_required_launch_template(resource.Properties.LaunchTemplateData, name)

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

is_metadata_service_enabled (resource_properties) {
    resource_properties.MetadataOptions.HttpEndpoint == "enabled"
} else {
    not common_lib.valid_key(resource_properties, "MetadataOptions")
} else {
    not common_lib.valid_key(resource_properties.MetadataOptions, "HttpEndpoint")
}

http_tokens_undefined_or_not_required_instance(resource_properties, name) = res {
    not common_lib.valid_key(resource_properties, "MetadataOptions")
    res := {
        "kev": sprintf("'Resources.%s.Properties.MetadataOptions' should  be defined with 'HttpTokens' field set to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.MetadataOptions' is not defined", [name]),
        "sk": sprintf("Resources.%s.Properties", [name]),
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
        "it": "MissingAttribute",
    }
} else = res { 
    common_lib.valid_key(resource_properties.MetadataOptions, "HttpTokens")
    not resource_properties.MetadataOptions.HttpTokens == "required"

    res := {
        "kev": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' should be defined to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.MetadataOptions.HttpTokens' is not defined to 'required'", [name]),
        "sk": sprintf("Resources.%s.Properties.MetadataOptions.HttpTokens", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "MetadataOptions", "HttpTokens"], []),
        "it": "IncorrectValue",
    }
}

http_tokens_undefined_or_not_required_launch_template(resource_properties, name) = res {
    not common_lib.valid_key(resource_properties, "MetadataOptions")
    res := {
        "kev": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions' should  be defined with 'HttpTokens' field set to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions' is not defined", [name]),
        "sk": sprintf("Resources.%s.Properties.LaunchTemplateData", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "LaunchTemplateData"], []),
        "it": "MissingAttribute",
    }
} else = res { 
    common_lib.valid_key(resource_properties, "MetadataOptions") 
    not common_lib.valid_key(resource_properties.MetadataOptions, "HttpTokens")

    res := {
        "kev": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions.HttpTokens' should be defined to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions.HttpTokens' is not defined", [name]),
        "sk": sprintf("Resources.%s.Properties.LaunchTemplateData.MetadataOptions", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "LaunchTemplateData","MetadataOptions"], []),
        "it": "MissingAttribute",
    }
} else = res { 
    common_lib.valid_key(resource_properties.MetadataOptions, "HttpTokens")
    not resource_properties.MetadataOptions.HttpTokens == "required"

    res := {
        "kev": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions.HttpTokens' should be defined to 'required'", [name]),
        "kav": sprintf("'Resources.%s.Properties.LaunchTemplateData.MetadataOptions.HttpTokens' is not defined to 'required'", [name]),
        "sk": sprintf("Resources.%s.Properties.LaunchTemplateData.MetadataOptions.HttpTokens", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "LaunchTemplateData","MetadataOptions", "HttpTokens"], []),
        "it": "IncorrectValue",
    }
}