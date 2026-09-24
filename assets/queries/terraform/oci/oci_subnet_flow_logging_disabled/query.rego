package Cx

import data.generic.common as common_lib

# RULE 1: Does not exist ningún log asociado a la subred (Missing)
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.resource.oci_core_subnet[subnet_name]

    associated_logs := [l |
        l := input.document[_].resource.oci_logging_log[_]
        contains(l.configuration.source.resource, subnet_name)
    ]
    count(associated_logs) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_subnet.%s", [subnet_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_subnet", subnet_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Subnet to have an associated VCN flow log",
        "keyActualValue": "Subnet does not have an associated VCN flow log",
    }
}

# RULE 2: Un log de flujo is disabled
CxPolicy[result] {
    doc := input.document[i]
    log := doc.resource.oci_logging_log[log_name]

    log.log_type == "SERVICE"
    object.get(log.configuration.source, "service", "") == "flowlogs"
    log.is_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_logging_log.%s.is_enabled", [log_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_logging_log", log_name, "is_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_enabled' should be 'true'",
        "keyActualValue": "'is_enabled' is 'false'",
    }
}

# RULE 3: Un log de flujo tiene el tipo incorrecto
CxPolicy[result] {
    doc := input.document[i]
    log := doc.resource.oci_logging_log[log_name]

    object.get(log.configuration.source, "service", "") == "flowlogs"
    log.log_type != "SERVICE"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_logging_log.%s.log_type", [log_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_logging_log", log_name, "log_type"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'log_type' should be 'SERVICE'",
        "keyActualValue": sprintf("'log_type' is '%s'", [log.log_type]),
    }
}

# RULE 4: Un log de flujo tiene el servicio incorrecto
CxPolicy[result] {
    doc := input.document[i]
    log := doc.resource.oci_logging_log[log_name]

    log.log_type == "SERVICE"
    object.get(log.configuration.source, "service", "") != "flowlogs"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_logging_log.%s.configuration.source.service", [log_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_logging_log", log_name, "configuration", "source", "service"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'service' should be 'flowlogs'",
        "keyActualValue": sprintf("'service' is '%s'", [object.get(log.configuration.source, "service", "undefined")]),
    }
}