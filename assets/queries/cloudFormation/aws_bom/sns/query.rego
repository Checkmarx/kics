package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	sns_topic := document[i].Resources[name]
	sns_topic.Type == "AWS::SNS::Topic"

	bom_output = {
		"resource_type": "AWS::SNS::Topic",
		"resource_name": get_topic_name(sns_topic),
		"resource_accessibility": "TO DO",
		"resource_encryption": get_encryption(sns_topic),
		"resource_vendor": "AWS",
		"resource_category": "Messaging",
		"policy": "TO DO",
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

get_topic_name(sns_topic) = name {
	name := sns_topic.Properties.TopicName
} else = name {
	name := "unknown"
}

get_encryption(sns_topic) = encryption {
	common_lib.valid_key(sns_topic.Properties, "KmsMasterKeyId")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
