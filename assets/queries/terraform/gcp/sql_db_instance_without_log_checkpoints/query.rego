package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_sql_database_instance[name]
    settings := resource.settings
    db_version := resource.database_version
    startswith(db_version, "POSTGRES")
    flags := settings.database_flags
    not has_flag_enabled(flags, "log_checkpoints")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_sql_database_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_sql_database_instance[%s] should have database_flag log_checkpoints set to on", [name]),
        "keyActualValue": sprintf("google_sql_database_instance[%s] is missing log_checkpoints flag", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags"], []),
    }
}

has_flag_enabled(flags, flag_name) {
    flag := flags[_]
    flag.name == flag_name
    flag.value == "on"
}
