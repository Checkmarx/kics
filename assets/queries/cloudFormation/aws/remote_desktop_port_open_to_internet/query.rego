package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	sec_group := doc.Resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, doc)

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(sec_group.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	cf_lib.entireNetwork(ingress)
	cf_lib.isTCP_and_port_exposed(ingress, 3389)

	results := cf_lib.get_search_values(ing_index, sec_group_name, ingresses_with_names.names)

	result := {
		"documentId": doc.id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not open the remote desktop port (3389)", [results.searchKey]),
		"keyActualValue": sprintf("'%s' opens the remote desktop port (3389)", [results.searchKey]),
		"searchLine": results.searchLine,
	}
}
