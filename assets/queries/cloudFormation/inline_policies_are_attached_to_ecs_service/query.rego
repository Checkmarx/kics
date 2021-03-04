package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	role := resource.Properties.Role

	policy := getInlinePolicy(role)
	policy != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Role' does not refer an inline IAM Policy", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Role' refers to inline IAM Policy '%s'", [name, policy]),
	}
}

getInlinePolicy(role) = policy {
	is_string(role)
	object.get(input.document[_].Resources, role, "undefined") != "undefined"
	object.get(input.document[_].Resources[role], "Type", "undefined") == "AWS::IAM::Policy"
	policy := role
} else = policy {
	is_object(role)
	object.get(role, "Ref", "undefined") != "undefined"
	ref := object.get(role, "Ref", "undefined")
	object.get(input.document[_].Resources, ref, "undefined") != "undefined"
	object.get(input.document[_].Resources[ref], "Type", "undefined") == "AWS::IAM::Policy"
	policy := ref
} else = "undefined" {
	true
}
