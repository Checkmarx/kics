package Cx

import data.generic.terraform as tf_lib

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

has_log_statement(flags_list) {
    flag := flags_list[_]
    flag.name == "log_statement"
}

# RULE 1: The 'log_statement' flag is not defined (Missing).
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_sql_database_instance[name]

    contains(resource.database_version, "POSTGRES")

    flags_list := ensure_array(resource.settings.database_flags)
    not has_log_statement(flags_list)

    result := {
        "documentId": doc.id,
        "resourceType": "google_sql_database_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'database_flags' should include 'log_statement' set to 'ddl', 'mod', or 'all'",
        "keyActualValue": "'log_statement' flag is missing (defaults to 'none')",
    }
}

# RULE 2: The 'log_statement' flag exists but is set to 'none'.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_sql_database_instance[name]

    contains(resource.database_version, "POSTGRES")

    flags_list := ensure_array(resource.settings.database_flags)
    flag := flags_list[_]
    flag.name == "log_statement"
    lower(flag.value) == "none"

    result := {
        "documentId": doc.id,
        "resourceType": "google_sql_database_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'log_statement' should be set to 'ddl', 'mod', or 'all'",
        "keyActualValue": "'log_statement' is set to 'none'",
    }
}