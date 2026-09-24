package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	lb := input.document[i].resource.ibm_is_lb[name]
	not common_lib.valid_key(lb, "type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "ibm_is_lb",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("ibm_is_lb[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'ibm_is_lb[%s]' should be set to private or private_path.", [name]),
		"keyActualValue": sprintf("'ibm_is_lb[%s]' is missing type property, defaults to public.", [name]),
		"searchLine": common_lib.build_search_line(["resource","ibm_is_lb", name], []),
	}
}

CxPolicy[result] {

	lb := input.document[i].resource.ibm_is_lb[name]
	lb.type == "public"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "ibm_is_lb",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("ibm_is_lb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'ibm_is_lb[%s]' should be set to private or private_path.", [name]),
		"keyActualValue": sprintf("'ibm_is_lb[%s]' is set to %s.", [name, lb.type]),
		"searchLine": common_lib.build_search_line(["resource","ibm_is_lb", name, "type"], []),
	}
}