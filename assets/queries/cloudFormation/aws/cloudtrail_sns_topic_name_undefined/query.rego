package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"

    isMissing(resource.Properties,"SnsTopicName")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SnsTopicName' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SnsTopicName' is undefined", [name]),
	}
}

isMissing(properties,attribute) {
    not common_lib.valid_key(properties, attribute)
}

isMissing(properties,attribute) {
    properties[attribute] == ""
}
