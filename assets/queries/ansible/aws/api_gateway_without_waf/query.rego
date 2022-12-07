package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	api := task[modules[m]]
	ans_lib.checkState(api)

	not has_waf_associated(api.stage)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "API Gateway Stage should be associated with a Web Application Firewall",
		"keyActualValue": "API Gateway Stage is not associated with a Web Application Firewall",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}

has_waf_associated(stage) {
	waf := {"community.aws.wafv2_resources", "wafv2_resources"}

    task2 := ans_lib.tasks[_][_]
	wafResource := task2[waf[_]]
    ans_lib.checkState(wafResource)
    contains(wafResource.arn, "arn:aws:apigateway:")
    associatedStage := split(wafResource.arn, "/")
    associatedStage[4] == stage
}
