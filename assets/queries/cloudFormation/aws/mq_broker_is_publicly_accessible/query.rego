package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::AmazonMQ::Broker"
	properties := resource.Properties

	properties.PubliclyAccessible

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PubliclyAccessible should be set to false or undefined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PubliclyAccessible is true", [name]),
	}
}
