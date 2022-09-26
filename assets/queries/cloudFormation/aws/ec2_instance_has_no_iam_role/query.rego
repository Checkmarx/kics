package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	common_lib.valid_key(resource.Properties, "IamInstanceProfile") == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	common_lib.valid_key(resource.Properties, "IamInstanceProfile")

	iamProfile := get_iam_instance_profile(resource.Properties.IamInstanceProfile)
	common_lib.valid_key(doc, iamProfile) == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IamInstanceProfile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' should have a matching IamInstanceProfile resource", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' does not have matching IamInstanceProfile resource", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	common_lib.valid_key(resource.Properties, "IamInstanceProfile")

	iamProfile := get_iam_instance_profile(resource.Properties.IamInstanceProfile)
	common_lib.valid_key(doc, iamProfile)
	common_lib.valid_key(doc[iamProfile].Properties, "Roles") == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [iamProfile]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Roles' should be set", [iamProfile]),
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
