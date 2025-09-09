package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_resources := {"aws_rds_cluster", "aws_db_instance"}

CxPolicy[result] {
    resource := input.document[i].resource[supported_resources[k]][name]

    res := tags_not_copied_to_snapshot(resource, name, supported_resources[k], ["resource",supported_resources[k]])

    result := {
        "documentId": input.document[i].id,
        "resourceType": supported_resources[k],
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"],
	  }
}

CxPolicy[result] {
	module := input.document[i].module[name]

    target_block := module[block]
	common_lib.get_module_equivalent_key("aws", module.source, supported_resources[k], block)

    res := tags_not_copied_to_snapshot(module, name, "module", ["module"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

tags_not_copied_to_snapshot(resource, name, type, path) = res {
    not common_lib.valid_key(resource, "copy_tags_to_snapshot")
    res := {
        "kev": sprintf("'%s[%s].copy_tags_to_snapshot' should be defined to true", [type, name]),
        "kav": sprintf("'%s[%s].copy_tags_to_snapshot' is not defined", [type, name]),
        "sk": sprintf("%s[%s]",[type, name]),
        "sl": common_lib.build_search_line(path, [name]),
        "it": "MissingAttribute",
    }
} else = res {
    resource.copy_tags_to_snapshot == false 
    res := {
        "kev": sprintf("'%s[%s].copy_tags_to_snapshot' should be set to true", [type, name]),
        "kav": sprintf("'%s[%s].copy_tags_to_snapshot' is set to false", [type, name]),
        "sk": sprintf("%s[%s].copy_tags_to_snapshot",[type, name]),
        "sl": common_lib.build_search_line(path, [name, "copy_tags_to_snapshot"]),
        "it": "IncorrectValue",
    }
}
