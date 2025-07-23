package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_instance[name]

    common_lib.valid_key(resource, "metadata_options")
    common_lib.valid_key(resource.metadata_options, "http_endpoint")
    not resource.metadata_options.http_endpoint == "enabled"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_instance[%s].metadata_options.http_endpoint", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "metadata_options", "http_endpoint"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'aws_instance[%s].metadata_options.http_endpoint' should be defined to 'enabled'", [name]),
        "keyActualValue": sprintf("'aws_instance[%s].metadata_options.http_tokens' is not defined to 'enabled'", [name]),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_instance[name]

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

http_tokens_undefined_or_not_required(resource, name) = res {
    not common_lib.valid_key(resource, "metadata_options")
    res := {
        "kev": sprintf("'aws_instance[%s].metadata_options' should be defined with 'http_tokens' field set to 'required'", [name]),
        "kav": sprintf("'aws_instance[%s].metadata_options.http_tokens' is not defined", [name]),
        "sk": sprintf("'aws_instance[%s]",[name]),
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