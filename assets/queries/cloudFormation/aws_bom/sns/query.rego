package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	sns_topic := document.Resources[name]
	sns_topic.Type == "AWS::SNS::Topic"

	info := cf_lib.get_resource_accessibility(name, "AWS::SNS::TopicPolicy", "Topics")

	bom_output = {
		"resource_type": "AWS::SNS::Topic",
		"resource_name": cf_lib.get_resource_name(sns_topic, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(sns_topic),
		"resource_vendor": "AWS",
		"resource_category": "Messaging",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}
