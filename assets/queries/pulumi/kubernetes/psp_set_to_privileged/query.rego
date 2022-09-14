package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "kubernetes:policy/v1beta1:PodSecurityPolicy"

	privileged := resource.properties.spec.privileged
	privileged != false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.spec.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "PSP should have 'privileged' set to false or not defined",
		"keyActualValue": "PSP has 'privileged' set to true",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["spec", "privileged"]),
	}
}
