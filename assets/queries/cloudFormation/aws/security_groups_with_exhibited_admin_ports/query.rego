package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

admin_ports := [20, 21, 22, 23, 115, 137, 138, 139, 2049, 3389]

CxPolicy[result] {
	doc := input.document[i]
	sec_group := doc.Resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := search_for_standalone_ingress(sec_group_name, doc)

	ingress_list := array.concat(ingresses_with_names.ingress_list, get_inline_ingress_list(sec_group))
	ingress := ingress_list[ing_index]

	cf_lib.entireNetwork(ingress)
	cf_lib.containsPort(ingress.FromPort, ingress.ToPort, admin_ports[x])

	results := get_search_values(ing_index, sec_group_name, ingresses_with_names.names)

	result := {
		"documentId": doc.id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "No exposed ingress rule should contain admin ports(20, 21, 22, 23, 115, 137, 138, 139, 2049, 3389)",
		"keyActualValue": sprintf("'%s' is exposed and contains admin port '%d'", [results.searchKey, admin_ports[x]]),
		"searchLine": results.searchLine,
	}
}

search_for_standalone_ingress(sec_group_name, doc) = ingresses_with_names {
  resources := doc.Resources

  names := [name |
    ingress := resources[name]
    ingress.Type == "AWS::EC2::SecurityGroupIngress"
    cf_lib.get_name(ingress.Properties.GroupId) == sec_group_name
  ]

  ingresses_with_names := {
    "ingress_list": [resources[name].Properties | name := names[_]],
    "names": names
  }
} else = {"ingress_list": [], "names": []}

get_search_values(ing_index, sec_group_name, names_list) = results {
	ing_index < count(names_list) # if ingress is standalone 

	results := {
		"searchKey" : sprintf("Resources.%s.Properties", [names_list[ing_index]]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[ing_index], "Properties"], []),
		"type" : "AWS::EC2::SecurityGroupIngress"
	}
} else = results {
	
	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d]", [sec_group_name, ing_index-count(names_list)]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", ing_index-count(names_list)], []),
		"type" : "AWS::EC2::SecurityGroup"
	}
}

get_inline_ingress_list(group) = [] {
	not common_lib.valid_key(group.Properties,"SecurityGroupIngress")
} else = group.Properties.SecurityGroupIngress