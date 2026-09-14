package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_elasticsearch_domain[name]
    not common_lib.valid_key(resource, "log_publishing_options")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_elasticsearch_domain",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_elasticsearch_domain[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options with log_type AUDIT_LOGS should be defined", [name]),
        "keyActualValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_elasticsearch_domain[name]
    log_opts := resource.log_publishing_options
    is_array(log_opts)
    audit_logs := [opt | opt := log_opts[_]; opt.log_type == "AUDIT_LOGS"]
    count(audit_logs) == 0
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_elasticsearch_domain",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_elasticsearch_domain[%s].log_publishing_options", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options should include AUDIT_LOGS", [name]),
        "keyActualValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options does not include AUDIT_LOGS", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "log_publishing_options"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_elasticsearch_domain[name]
    log_opts := resource.log_publishing_options
    is_object(log_opts)
    log_opts.log_type != "AUDIT_LOGS"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_elasticsearch_domain",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_elasticsearch_domain[%s].log_publishing_options.log_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options should include AUDIT_LOGS", [name]),
        "keyActualValue": sprintf("aws_elasticsearch_domain[%s].log_publishing_options.log_type is %s", [name, log_opts.log_type]),
        "searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "log_publishing_options", "log_type"], []),
    }
}
