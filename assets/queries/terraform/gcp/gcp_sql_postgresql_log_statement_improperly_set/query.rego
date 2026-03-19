package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

has_log_statement(flags_list) {
    flag := flags_list[_]
    flag.name == "log_statement"
}

# REGLA 1: El flag 'log_statement' no está definido (Ausente).
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_sql_database_instance[name]

    contains(resource.database_version, "POSTGRES")

    flags_list := ensure_array(resource.settings.database_flags)
    not has_log_statement(flags_list)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_sql_database_instance.%s.settings.database_flags", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'database_flags' should include 'log_statement' set to 'ddl', 'mod', or 'all'",
        "keyActualValue": "'log_statement' flag is missing (defaults to 'none')",
    }
}

# REGLA 2: El flag 'log_statement' existe pero está en 'none'.
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
        "searchKey": sprintf("resource.google_sql_database_instance.%s.settings.database_flags", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'log_statement' should be set to 'ddl', 'mod', or 'all'",
        "keyActualValue": "'log_statement' is set to 'none'",
    }
}