package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"

	isMissing(resource.Properties, "SnsTopicName")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SnsTopicName' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SnsTopicName' is undefined", [name]),
	}
}

isMissing(properties, attribute) {
	not common_lib.valid_key(properties, attribute)
}

isMissing(properties, attribute) {
	properties[attribute] == ""
}
