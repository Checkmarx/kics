package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := ["aws_instance", "aws_launch_configuration", "aws_launch_template"]

CxPolicy[result] {
    resource := input.document[i].resource[types[i2]][name]

    is_metadata_service_enabled(resource)

    res := http_tokens_undefined_or_not_required(resource, name, types[i2], ["resource",types[i2]])

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
    }
}

CxPolicy[result] {
	module := input.document[i].module[name]

    target_block := module[block]
	common_lib.get_module_equivalent_key("aws", module.source, types[i2], block)

	is_metadata_service_enabled(module)

    res := http_tokens_undefined_or_not_required(module, name, "module", ["module"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

is_metadata_service_enabled (resource) {
    resource.metadata_options.http_endpoint == "enabled"
} else {
    not common_lib.valid_key(resource, "metadata_options")
} else {
    not common_lib.valid_key(resource.metadata_options, "http_endpoint")
}

http_tokens_undefined_or_not_required(resource, name, type, path) = res {
    not common_lib.valid_key(resource, "metadata_options")
    res := {
        "kev": sprintf("'%s[%s].metadata_options' should be defined with 'http_tokens' field set to 'required'", [type, name]),
        "kav": sprintf("'%s[%s].metadata_options' is not defined", [type, name]),
        "sk": sprintf("%s[%s]",[type, name]),
        "sl": common_lib.build_search_line(path, [name]),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(resource, "metadata_options")
    not common_lib.valid_key(resource.metadata_options, "http_tokens")

    res := {
        "kev": sprintf("'%s[%s].metadata_options.http_tokens' should be defined to 'required'", [type, name]),
        "kav": sprintf("'%s[%s].metadata_options.http_tokens' is not defined", [type, name]),
        "sk": sprintf("%s[%s].metadata_options", [type, name]),
        "sl": common_lib.build_search_line(path, [name, "metadata_options"]),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(resource.metadata_options, "http_tokens")
    not resource.metadata_options.http_tokens == "required"

    res := {
        "kev": sprintf("'%s[%s].metadata_options.http_tokens' should be defined to 'required'", [type, name]),
        "kav": sprintf("'%s[%s].metadata_options.http_tokens' is not defined to 'required'", [type, name]),
        "sk": sprintf("%s[%s].metadata_options.http_tokens", [type, name]),
        "sl": common_lib.build_search_line(path, [name, "metadata_options", "http_tokens"]),
        "it": "IncorrectValue",
    }
}
