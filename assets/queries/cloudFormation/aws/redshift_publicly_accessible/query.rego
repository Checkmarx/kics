package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"
	not common_lib.valid_key(resource.Properties, "PubliclyAccessible")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' should be set to false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is true", [name]),
	}
}
