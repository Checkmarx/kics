package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	sns_topic := document[i].Resources[name]
	sns_topic.Type == "AWS::SNS::Topic"

	info := cf_lib.get_resource_accessibility(name, "AWS::SNS::TopicPolicy", "Topics")

	bom_output = {
		"resource_type": "AWS::SNS::Topic",
		"resource_name": get_topic_name(sns_topic),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(sns_topic),
		"resource_vendor": "AWS",
		"resource_category": "Messaging",
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

get_topic_name(sns_topic) = name {
	name := sns_topic.Properties.TopicName
} else = name {
	name := common_lib.get_tag_name_if_exists(sns_topic)
} else = name {
	name := "unknown"
}

