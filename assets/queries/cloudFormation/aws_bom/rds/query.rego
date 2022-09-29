package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource := document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	info := cf_lib.get_resource_accessibility(name, "AWS::RDS::DBInstance", "Queues")

	bom_output = {
		"resource_type": "AWS::RDS::DBInstance",
		"resource_name": cf_lib.get_resource_name(sqs_queue, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(sqs_queue),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_resource_accessibility(resource) = accessibility{
    resource.PubliclyAccessible == true
    accessibility:= "public"
} else = accessibility{
    resource.PubliclyAccessible == false
    accessibility:= "private"
} else = accessibility{
    not common_lib.valid_key(resource,"PubliclyAccessible")
    not common_lib.valid_key(resource,"DBSubnetGroupName")

} else = accessibility{

} else = accessibility{
    accessibility:= "private"
}

get_region(resource) {
    
}