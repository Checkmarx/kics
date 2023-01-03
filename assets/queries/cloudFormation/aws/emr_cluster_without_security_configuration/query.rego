package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EMR::Cluster"
	properties := resource.Properties

	not common_lib.valid_key(properties, "SecurityConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityConfiguration should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EMR::Cluster"
	properties := resource.Properties
	sc_name := properties.SecurityConfiguration

	not settings_are_equal(document[i].Resources, sc_name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s has the same name as the AWS::EMR::SecurityConfiguration Resource", [name]),
		"keyActualValue": sprintf("Resources.%s has a different name from AWS::EMR::SecurityConfiguration Resource", [name]),
	}
}

settings_are_equal(resource, sc_name) {
	resource[name].Type == "AWS::EMR::SecurityConfiguration"
	name == sc_name
}
