package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticsearch:Domain"

	not common_lib.valid_key(resource.properties, "logPublishingOptions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources.%s.properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'logPublishingOptions' should be defined",
		"keyActualValue": "Attribute 'logPublishingOptions' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticsearch:Domain"

	log := resource.properties.logPublishingOptions[index]

	not common_lib.valid_key(log, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources.%s.properties.logPublishingOptions[%d].logType", [name, index]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'enabled' should be defined and set to 'true'",
		"keyActualValue": "Attribute 'enabled' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties","logPublishingOptions", index, "logType"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:elasticsearch:Domain"

	log := resource.properties.logPublishingOptions[index]
	log.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources.%s.properties.logPublishingOptions[%d].logType", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enabled' should be set to 'true'",
		"keyActualValue": "Attribute 'enabled' is set to 'false'",
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "logPublishingOptions", index, "enabled"], []),
	}
}