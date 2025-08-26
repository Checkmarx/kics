package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] { # iam_database_authentication_enabled not defined for resource
    resource := input.document[i].resource.aws_rds_cluster[name]

    not common_lib.valid_key(resource, "iam_database_authentication_enabled")
    valid_for_iam_engine_and_version_check_edited(resource, "engine", "engine_version")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_rds_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_rds_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
        "keyActualValue": "'iam_database_authentication_enabled' is undefined",
        "searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name], []),
        "remediation": "iam_database_authentication_enabled = true",
        "remediationType": "addition",
    }
}

CxPolicy[result] { # iam_database_authentication_enabled set to false for resource
    resource := input.document[i].resource.aws_rds_cluster[name]

    resource.iam_database_authentication_enabled == false
    valid_for_iam_engine_and_version_check_edited(resource, "engine", "engine_version")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_rds_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_rds_cluster[%s].iam_database_authentication_enabled", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
        "keyActualValue": "'iam_database_authentication_enabled' is defined to false",
        "searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name, "iam_database_authentication_enabled"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
        "remediationType": "replacement",
    }
}

CxPolicy[result] { # iam_database_authentication_enabled not defined for module
    module := input.document[i].module[name]

    keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_rds_cluster", "iam_database_authentication_enabled")

    not common_lib.valid_key(module, keyToCheck)
    valid_for_iam_engine_and_version_check_edited(module, "engine", "engine_version")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "n/a",
        "resourceName": "n/a",
        "searchKey": sprintf("module[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
        "keyActualValue": "'iam_database_authentication_enabled' is undefined",
        "searchLine": common_lib.build_search_line(["module", name], []),
        "remediation": "iam_database_authentication_enabled = true",
        "remediationType": "addition",
    }
}

CxPolicy[result] { # iam_database_authentication_enabled set to false for module
    module := input.document[i].module[name]

    keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_rds_cluster", "iam_database_authentication_enabled")

    module[keyToCheck] == false
    valid_for_iam_engine_and_version_check_edited(module, "engine", "engine_version")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "n/a",
        "resourceName": "n/a",
        "searchKey": sprintf("module[%s].iam_database_authentication_enabled", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
        "keyActualValue": "'iam_database_authentication_enabled' is defined to false",
        "searchLine": common_lib.build_search_line(["module", name, "iam_database_authentication_enabled"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
        "remediationType": "replacement",
    }
}

valid_for_iam_engine_and_version_check_edited(resource, engineVar, engineVersionVar) {
    key_list := [engineVar, engineVersionVar]
    contains(lower(resource[engineVar]), "mariadb")
    supported_versions := {"10.6", "10.11", "11.4"}
    version_check := {x | x := resource[key_list[_]]; contains(x, supported_versions[_])}
    count(version_check) > 0
} else {
    contains(lower(resource[engineVar]), "mariadb")
    not common_lib.valid_key(resource, engineVersionVar)
} else {
    engines_that_supports_iam := ["aurora-postgresql", "postgres", "mysql"]
	contains(lower(resource[engineVar]), engines_that_supports_iam[_])
} 