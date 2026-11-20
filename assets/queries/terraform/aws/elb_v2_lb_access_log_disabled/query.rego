package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    load_balancer := get_load_balancer(input.document[i].resource)
    resource := input.document[i].resource[load_balancer][name]

    not common_lib.valid_key(resource, "access_logs")

    result := {
        "documentId": input.document[i].id,
        "resourceType": load_balancer,
		"resourceName": tf_lib.get_specific_resource_name(resource, load_balancer, name),
        "searchKey": sprintf("%s[%s]", [load_balancer,name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'access_logs.enabled' should be defined and set to true",
        "keyActualValue": "'access_logs' is undefined",
        "searchLine": common_lib.build_search_line(["resource", load_balancer, name], []),
    }
}

CxPolicy[result] {
    load_balancer := get_load_balancer(input.document[i].resource)
    resource := input.document[i].resource[load_balancer][name]

    log_info := get_access_logs(resource)[_]
    not common_lib.valid_key(log_info.block, "enabled")

    result := {
        "documentId": input.document[i].id,
        "resourceType": load_balancer,
		"resourceName": tf_lib.get_specific_resource_name(resource, load_balancer, name),
        "searchKey": get_search_key(load_balancer, name, log_info.index, "access_logs"),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'access_logs.enabled' should be defined and set to true",
        "keyActualValue": "'access_logs.enabled' is undefined",
        "searchLine": get_search_line(load_balancer, name, log_info.index, ["access_logs"]),
    }
}

CxPolicy[result] {
    load_balancer := get_load_balancer(input.document[i].resource)
    resource := input.document[i].resource[load_balancer][name]

    log_info := get_access_logs(resource)[_]
    log_info.block.enabled != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": load_balancer,
		"resourceName": tf_lib.get_specific_resource_name(resource, load_balancer, name),
        "searchKey": get_search_key(load_balancer, name, log_info.index, "access_logs.enabled"),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'access_logs.enabled' should be defined and set to true",
        "keyActualValue": "'access_logs.enabled' is not set to true",
        "searchLine": get_search_line(load_balancer, name, log_info.index, ["access_logs", "enabled"]),
    }
}

# access_logs can be parsed as a single block (object) or, when written as a
# list (access_logs = [{ ... }]) or as multiple blocks, as an array. Normalize
# both shapes to a list of {block, index} so the checks above behave the same.
get_access_logs(resource) = logs {
    is_array(resource.access_logs)
    logs := [{"block": block, "index": idx} | block := resource.access_logs[idx]]
} else = logs {
    logs := [{"block": resource.access_logs, "index": null}]
}

get_search_key(lb, name, index, suffix) = searchKey {
    index != null
    searchKey := sprintf("%s[%s].access_logs[%d].%s", [lb, name, index, trim_prefix(suffix, "access_logs.")])
} else = searchKey {
    searchKey := sprintf("%s[%s].%s", [lb, name, suffix])
}

get_search_line(lb, name, index, path_elements) = searchLine {
    index != null
    full_path := array.concat(["resource", lb, name], path_elements)
    path_with_index := array.concat(array.slice(full_path, 0, 4), array.concat([index], array.slice(full_path, 4, count(full_path))))
    searchLine := common_lib.build_search_line(path_with_index, [])
} else = searchLine {
    full_path := array.concat(["resource", lb, name], path_elements)
    searchLine := common_lib.build_search_line(full_path, [])
}

get_load_balancer(resource) = lb {
    common_lib.valid_key(resource,"aws_lb")
    lb = "aws_lb"
} else = lb {
    common_lib.valid_key(resource,"aws_alb")
    lb = "aws_alb"
}
