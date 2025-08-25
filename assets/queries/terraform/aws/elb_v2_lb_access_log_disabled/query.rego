package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    load_balancer := get_load_balancer(input.document[i].resource)
    load_balancer != ""
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
    load_balancer != ""
    resource := input.document[i].resource[load_balancer][name]

    not common_lib.valid_key(resource.access_logs, "enabled")  

    result := {
        "documentId": input.document[i].id,
        "resourceType": load_balancer,
		"resourceName": tf_lib.get_specific_resource_name(resource, load_balancer, name),
        "searchKey": sprintf("%s[%s].access_logs", [load_balancer,name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'access_logs.enabled' should be defined and set to true",
        "keyActualValue": "'access_logs.enabled' is undefined",
        "searchLine": common_lib.build_search_line(["resource", load_balancer, name, "access_logs"], []),
    }
}

CxPolicy[result] {
    load_balancer := get_load_balancer(input.document[i].resource)
    load_balancer != ""
    resource := input.document[i].resource[load_balancer][name]

    resource.access_logs.enabled != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": load_balancer,
		"resourceName": tf_lib.get_specific_resource_name(resource, load_balancer, name),
        "searchKey": sprintf("%s[%s].access_logs.enabled", [load_balancer,name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'access_logs.enabled' should be defined and set to true",
        "keyActualValue": "'access_logs.enabled' is not set to true",
        "searchLine": common_lib.build_search_line(["resource", load_balancer, name, "access_logs", "enabled"], []),
    }
}

get_load_balancer(resource) = lb {
    common_lib.valid_key(resource,"aws_lb")
    lb = "aws_lb"
} else = lb {
    common_lib.valid_key(resource,"aws_alb")
    lb = "aws_alb"
} else = ""

