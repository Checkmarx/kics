package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document = input.document[i]
	resource = document.resource.aws_autoscaling_group[name]

	not common_lib.valid_key(resource, "load_balancers")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_autoscaling_group[%s].load_balancers", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers is set and not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is undefined", [name]),
	}
}
