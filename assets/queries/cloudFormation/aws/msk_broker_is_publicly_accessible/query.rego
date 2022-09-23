package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::MSK::Cluster"


	resource.Properties.BrokerNodeGroupInfo.ConnectivityInfo.PublicAccess.Type == "SERVICE_PROVIDED_EIPS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.BrokerNodeGroupInfo.ConnectivityInfo.PublicAccess.Type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BrokerNodeGroupInfo.ConnectivityInfo.PublicAccess.Type should be set to 'DISABLED' or undefined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.BrokerNodeGroupInfo.ConnectivityInfo.PublicAccess.Type is set to 'SERVICE_PROVIDED_EIPS'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties","BrokerNodeGroupInfo","ConnectivityInfo","PublicAccess", "Type"], []),
	}
}
