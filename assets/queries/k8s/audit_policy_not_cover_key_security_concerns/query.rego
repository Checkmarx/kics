package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

needed_level_per_resource := {
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

    # map the current resources and what levels they are defined in
    resource_rule_map := { resource_rule_map |
    	rule := resource.rules[_]
        # get resource that is defined in the rule and match the ones in needed_level_per_resource
        rule.resources[_].resources[_] == needed_level_per_resource[x].resource;
        # build retuned map with resource and level
        resource_rule_map:= {"resource":needed_level_per_resource[x].resource,"level": rule.level} #
    }

    # get the resources that are not defined in the needed levels
    not hasResourceLevel(needed_level_per_resource[y].resource, needed_level_per_resource[y].levels, resource_rule_map)

    current_levels := [ current_levels |
        resource_rule_map[k].resource == needed_level_per_resource[y].resource;
        resource_rule_map[k].level == needed_level_per_resource[y].levels[_];
        current_levels := resource_rule_map[k].level
    ]

    result := {
        "documentId": resource.id,
        "resourceType": resource.kind,
        "resourceName": "n/a",
        "searchKey": "kind={{Policy}}.rules",
        "searchValue": needed_level_per_resource[y].resource,
        "issueType": "MissingAttribute",
        "keyExpectedValue":sprintf("Resource '%s' should be defined in one of following levels '%s'",[needed_level_per_resource[y].resource, needed_level_per_resource[y].levels]),
        "keyActualValue": sprintf("Resource '%s' is currently defined with the following levels '%s'",[needed_level_per_resource[y].resource, current_levels]),
        "searchLine": common_lib.build_search_line(["rules"], []),
    }
}

hasResourceLevel(resource, levels, res_rules){
	rule := res_rules[_]
    rule.resource == resource
    rule.level == levels[_]
}
