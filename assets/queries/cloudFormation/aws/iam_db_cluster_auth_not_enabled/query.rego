package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    docs := input.document[i]
    [path, Resources] := walk(docs)
    resource := Resources[name]
    resource.Type == "AWS::RDS::DBCluster"

    not common_lib.valid_key(resource.Properties, "EnableIAMDatabaseAuthentication")
    valid_for_iam_engine_and_version_check_edited(resource.Properties, "Engine", "EngineVersion")

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableIAMDatabaseAuthentication' should be defined (disabled by default)", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.EnableIAMDatabaseAuthentication' is not defined (disabled by default)", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
    }
}

CxPolicy[result] {
    docs := input.document[i]
    [path, Resources] := walk(docs)
    resource := Resources[name]
    resource.Type == "AWS::RDS::DBCluster"

    common_lib.valid_key(resource.Properties, "EnableIAMDatabaseAuthentication")
    cf_lib.isCloudFormationFalse(resource.Properties.EnableIAMDatabaseAuthentication)
    valid_for_iam_engine_and_version_check_edited(resource.Properties, "Engine", "EngineVersion")

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableIAMDatabaseAuthentication' should be defined to true", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.EnableIAMDatabaseAuthentication' is defined to false", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name, "Properties", "EnableIAMDatabaseAuthentication"], [])
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