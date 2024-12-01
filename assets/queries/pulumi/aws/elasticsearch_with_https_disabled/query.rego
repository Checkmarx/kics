package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[name]
	resource.type == "aws.elasticsearch.Domain"

	resource.properties.domainEndpointOptions.enforceHTTPS == false

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.domainEndpointOptions.enforceHTTPS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resources[%s].properties.domainEndpointOptions.enforceHTTPS should be set to 'true'", [name]),
		"keyActualValue": sprintf("resources[%s].properties.domainEndpointOptions.enforceHTTPS is set to 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "domainEndpointOptions", "enforceHTTPS"], []),
	}
}
