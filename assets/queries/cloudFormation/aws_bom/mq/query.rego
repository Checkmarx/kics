package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	mq := document[i].Resources[name]
	mq.Type == "AWS::AmazonMQ::Broker"

	bom_output = {
		"resource_type": "AWS::AmazonMQ::Broker",
		"resource_name": cf_lib.get_resource_name(mq, name),
		# RabbitMQ or ActiveMQ
		"resource_engine": mq.Properties.EngineType,
		"resource_accessibility": check_publicly_accessible(mq),
		"resource_encryption": cf_lib.get_encryption(mq),
		"resource_vendor": "AWS",
		"resource_category": "Queues",
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

check_publicly_accessible(resource) = accessibility {
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
	accessibility := "public"
} else = accessibility {
	accessibility := "private"
}
