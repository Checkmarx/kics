package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

resources := {
	{"resource": "secrets","levels": ["Metadata"]},
    {"resource": "tokenreviews","levels": ["Metadata"]},
    {"resource": "configmaps","levels": ["Metadata"]},
    {"resource": "pods","levels": ["Metadata"]},
    {"resource": "deployments","levels": ["Metadata"]},
    {"resource": "pods/exec","levels": ["Metadata","Request","RequestResponse"]},
    {"resource": "pods/portforward","levels": ["Metadata","Request","RequestResponse"]},
    {"resource": "pods/proxy","levels": ["Metadata","Request","RequestResponse"]},
    {"resource": "services/proxy","levels": ["Metadata","Request","RequestResponse"]}
}

CxPolicy[result] {
    resource := input.document[i]
    resource.kind == "Policy"
    startswith(resource.apiVersion, "audit")
	res_rules := {res_rule | rule := resource.rules[_]; rule.resources[_].resources[_] == resources[x].resource; res_rule:= {"resource": resources[x].resource , "level": rule.level}}
	resource_cont := resources[_]
    resource_rule := resource_cont.resource
    levels := resource_cont.levels
    not hasResourceLevel(resource_rule, levels, res_rules)

	result := {
		"documentId": input.document[i].id,
        "resourceType": resource.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{Policy}}.rules",
		"issueType": "MissingAttribute",
		"keyExpectedValue":sprintf("Resource '%s' should be defined in the following levels '%s'",[resource_rule, levels]),
		"keyActualValue": sprintf("Resource '%s' is not defined in the following levels '%s'",[resource_rule, levels]),
	}
}

hasResourceLevel(resource, levels, res_rules){
	rule := res_rules[_]
    rule.resource == resource
    rule.level == levels[_]
}
