package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	aws_mq_broker_resource := input.document[i].resource.aws_mq_broker[name]

	bom_output = {
		"resource_type": "aws_mq_broker",
		"resource_name": aws_mq_broker_resource.broker_name,
		# RabbitMQ or ActiveMQ
		"resource_engine": aws_mq_broker_resource.engine_type,
		"resource_accessibility": check_publicly_accessible(aws_mq_broker_resource),
		"resource_encryption": common_lib.get_encryption_if_exists(aws_mq_broker_resource),
		"resource_vendor": "AWS",
		"resource_category": "Queues",
		"user_name": aws_mq_broker_resource.user.username,
		"is_default_password": terra_lib.is_default_password(aws_mq_broker_resource.user.password), 
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_mq_broker[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_mq_broker", name], []),
		"value": json.marshal(bom_output),
	}
}

check_publicly_accessible(resource) = accessibility {
	accessibility := resource.publicly_accessible
} else = accessibility {
	accessibility := false
}
