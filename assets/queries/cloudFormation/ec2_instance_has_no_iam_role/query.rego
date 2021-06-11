package Cx

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	object.get(resource.Properties, "IamInstanceProfile", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	object.get(resource.Properties, "IamInstanceProfile", "undefined") != "undefined"

	iamProfile := get_iam_instance_profile(resource.Properties.IamInstanceProfile)
	object.get(doc, iamProfile, "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IamInstanceProfile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' has matching IamInstanceProfile resource", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' does not have matching IamInstanceProfile resource", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	object.get(resource.Properties, "IamInstanceProfile", "undefined") != "undefined"

	iamProfile := get_iam_instance_profile(resource.Properties.IamInstanceProfile)
	object.get(doc, iamProfile, "undefined") != "undefined"
	object.get(doc[iamProfile].Properties, "Roles", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [iamProfile]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Roles' is set", [iamProfile]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Roles' is undefined", [iamProfile]),
	}
}

get_iam_instance_profile(instance_profile) = name {
	is_object(instance_profile)
	name := instance_profile.Ref
} else = name {
	is_string(instance_profile)
	name := instance_profile
}
