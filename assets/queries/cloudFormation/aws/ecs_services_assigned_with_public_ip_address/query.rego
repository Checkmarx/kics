package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::ECS::Service"

    resource.Properties.NetworkConfiguration.AwsvpcConfiguration.AssignPublicIp == "ENABLED"

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.NetworkConfiguration.AwsvpcConfiguration.AssignPublicIp", [name]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": "'AssignPublicIp' field should be defined to 'DISABLED' (defaults to 'DISABLED')",
		"keyActualValue": "'AssignPublicIp' field is defined to 'ENABLED'",
	}
}