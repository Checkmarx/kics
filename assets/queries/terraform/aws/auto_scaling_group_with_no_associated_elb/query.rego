package Cx

CxPolicy[result] {
	resource = input.document[i].resource.aws_autoscaling_group[name]

	object.get(resource, "load_balancers", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_autoscaling_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers is set and not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is undefined", [name]),
	}
}

CxPolicy[result] {
	resource = input.document[i].resource.aws_autoscaling_group[name]

	resource.load_balancers == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_autoscaling_group[%s].load_balancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers is not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is empty", [name]),
	}
}
