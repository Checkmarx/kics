package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource := document[i].Resources[name]
	resource.Type == "AWS::Cassandra::Table"

	bom_output = {
		"resource_type": "AWS::Cassandra::Table",
		"resource_name": cf_lib.get_resource_name(resource, name),
		"resource_accessibility": "unknown",
		"resource_encryption": cf_lib.get_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(bom_output),
	}
}
