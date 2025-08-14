package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_instance[name]

    is_metadata_service_enabled(resource)

    res := http_tokens_undefined_or_not_required(resource, name)

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

is_metadata_service_enabled (resource) {
    resource.metadata_options.http_endpoint == "enabled" 
} else {
    not common_lib.valid_key(resource, "metadata_options")
} else {
    not common_lib.valid_key(resource.metadata_options, "http_endpoint")
}

http_tokens_undefined_or_not_required(resource, name) = res {
    not common_lib.valid_key(resource, "metadata_options")
    res := {
        "kev": sprintf("'aws_instance[%s].metadata_options' should be defined with 'http_tokens' field set to 'required'", [name]),
        "kav": sprintf("'aws_instance[%s].metadata_options' is not defined", [name]),
        "sk": sprintf("aws_instance[%s]",[name]),
        "sl": common_lib.build_search_line(["resource", "aws_instance", name], []),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(resource, "metadata_options")
    not common_lib.valid_key(resource.metadata_options, "http_tokens")

    res := {
        "kev": sprintf("'aws_instance[%s].metadata_options.http_tokens' should be defined to 'required'", [name]),
        "kav": sprintf("'aws_instance[%s].metadata_options.http_tokens' is not defined", [name]),
        "sk": sprintf("aws_instance[%s].metadata_options", [name]),
        "sl": common_lib.build_search_line(["resource", "aws_instance", name, "metadata_options"], []),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(resource.metadata_options, "http_tokens")
    not resource.metadata_options.http_tokens == "required"

    res := {
        "kev": sprintf("'aws_instance[%s].metadata_options.http_tokens' should be defined to 'required'", [name]),
        "kav": sprintf("'aws_instance[%s].metadata_options.http_tokens' is not defined to 'required'", [name]),
        "sk": sprintf("aws_instance[%s].metadata_options.http_tokens", [name]),
        "sl": common_lib.build_search_line(["resource", "aws_instance", name, "metadata_options", "http_tokens"], []),
        "it": "IncorrectValue",
    }
}