package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	apiGateway := task[modules[m]]
	ansLib.checkState(apiGateway)

	content_info := get_content(apiGateway)

	object.get(content_info.content.components.securitySchemes[x], "x-amazon-apigateway-authorizer", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], content_info.attribute]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s' has a authorizer set", [modules[m], content_info.attribute]),
		"keyActualValue": sprintf("'%s.%s' does not have a authorizer set", [modules[m], content_info.attribute]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	apiGateway := task[modules[m]]
	ansLib.checkState(apiGateway)

	text := apiGateway.swagger_text

	not contains(text, "x-amazon-apigateway-authorizer")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.swagger_text", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.swagger_text' has a authorizer set", [modules[m]]),
		"keyActualValue": sprintf("'%s.swagger_text' does not have a authorizer set", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	apiGateway := task[modules[m]]
	ansLib.checkState(apiGateway)

	without_authorizer(apiGateway)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' has swagger_file, swagger_text or swagger_dict set", [modules[m]]),
		"keyActualValue": sprintf("'%s' does not have swagger_file, swagger_text or swagger_dict set", [modules[m]]),
	}
}

without_authorizer(apiGateway) {
	object.get(apiGateway, "swagger_file", "undefined") == "undefined"
	object.get(apiGateway, "swagger_text", "undefined") == "undefined"
	object.get(apiGateway, "swagger_dict", "undefined") == "undefined"
}

get_content(apiGateway) = content_info {
	content := apiGateway.swagger_file.content
	content_info := {"content": content, "attribute": "swagger_file"}
} else = content_info {
	content := apiGateway.swagger_dict
	content_info := {"content": content, "attribute": "swagger_dict"}
}
