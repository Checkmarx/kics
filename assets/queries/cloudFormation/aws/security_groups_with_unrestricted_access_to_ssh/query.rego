package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[sec_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[y])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	cf_lib.entireNetwork(ingress)
	cf_lib.isTCP_and_port_exposed(ingress, 22)

	results := cf_lib.get_search_values_for_ingress_resources(ing_index, sec_group_name, ingresses_with_names.names, y, i)

	result := {
		"documentId": input.document[results.doc_index].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not open the SSH port (22)", [results.searchKey]),
		"keyActualValue": sprintf("'%s' opens the SSH port (22)", [results.searchKey]),
		"searchLine": results.searchLine,
	}
}
