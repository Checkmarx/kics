package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	apiGateway := task[modules[m]]
	ansLib.checkState(apiGateway)

	content_info := get_content(apiGateway)

	securityScheme := content_info.content.components.securitySchemes[x]
	not common_lib.valid_key(securityScheme, "x-amazon-apigateway-authorizer")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], content_info.attribute]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s' should have an authorizer set", [modules[m], content_info.attribute]),
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.swagger_text", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.swagger_text' should have an authorizer set", [modules[m]]),
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should have swagger_file, swagger_text or swagger_dict set", [modules[m]]),
		"keyActualValue": sprintf("'%s' does not have swagger_file, swagger_text or swagger_dict set", [modules[m]]),
	}
}

without_authorizer(apiGateway) {
	not common_lib.valid_key(apiGateway, "swagger_file")
	not common_lib.valid_key(apiGateway, "swagger_dict")
	not common_lib.valid_key(apiGateway, "swagger_text")
}

get_content(apiGateway) = content_info {
	content := apiGateway.swagger_file
	content_info := {"content": content, "attribute": "swagger_file"}
} else = content_info {
	content := apiGateway.swagger_dict
	content_info := {"content": content, "attribute": "swagger_dict"}
}
