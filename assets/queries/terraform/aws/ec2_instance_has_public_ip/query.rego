package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	object.get(resource, "associate_public_ip_address", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance.%s.associate_public_ip_address is defined", [name]),
		"keyActualValue": sprintf("aws_instance.%s.associate_public_ip_address is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	isTrue(resource.associate_public_ip_address)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.%s.associate_public_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance.%s.associate_public_ip_address is false", [name]),
		"keyActualValue": sprintf("aws_instance.%s.associate_public_ip_address is true", [name]),
	}
}

isTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
