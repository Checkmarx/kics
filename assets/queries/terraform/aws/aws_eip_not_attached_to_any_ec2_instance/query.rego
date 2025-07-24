package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib


CxPolicy[result] {
	EIP := input.document[i].resource.aws_eip[name]
    
    bool_has_valid_vpc(EIP) 
    not has_valid_instance(EIP,input.document[i])
    not has_valid_network_interface(EIP, input.document[i])
    not has_eip_associated(name, input.document[i])
    not has_nat_gateway(name, input.document[i])
    not has_transfer_server(name, input.document[i])
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eip",
		"resourceName": tf_lib.get_resource_name(EIP, name),
		"searchKey": sprintf("aws_eip[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_eip", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "All EIPs should be attached",
		"keyActualValue": "EIP is not attached"
	}
}

CxPolicy[result] {
	EIP := input.document[i].resource.aws_eip[name]

    actualValue := has_valid_vpc(EIP)
    actualValue != "yes"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eip",
		"resourceName": tf_lib.get_resource_name(EIP, name),
		"searchKey": sprintf("aws_eip[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_eip", name ], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "All EIPs should be attached",
		"keyActualValue": actualValue
	}
}

has_valid_vpc(resource) = actualValue{
    #legacy
    common_lib.valid_key(resource,"vpc")
    resource.vpc == true
    actualValue = "yes"
} else = actualValue {
    common_lib.valid_key(resource,"domain")
    resource.domain == "vpc"
    actualValue = "yes"
} else = actualValue {
    #legacy
    common_lib.valid_key(resource,"vpc")
    actualValue = "Vpc is not set to true"
} else = actualValue {
    common_lib.valid_key(resource,"domain")
    actualValue = "Domain is not set to \"vpc\""
} else = actualValue {
    actualValue = "EIP is missing domain field set to \"vpc\""
}

bool_has_valid_vpc(resource) = true {
    #legacy
    common_lib.valid_key(resource,"vpc")
    resource.vpc == true
} else = true {
    common_lib.valid_key(resource,"domain")
    resource.domain == "vpc"
} else = false

has_valid_instance(resource,doc) {
    common_lib.valid_key(resource,"instance")
    instance_name = split(resource.instance,".")[1]
    instance_type = get_allowed_types(split(resource.instance,".")[0])

    resource_exists(instance_name,instance_type,doc)
}

has_eip_associated(eip_name, doc) {
  association := doc.resource.aws_eip_association[_]
  allocation_target_name = split(association.allocation_id,".")[1]
  allocation_target_name == eip_name

  instance_id := association.instance_id
  instance_type = get_allowed_types(split(instance_id,".")[0])
  instance_type != "none"
  instance_name = split(instance_id,".")[1]

  resource_exists(instance_name,instance_type,doc)
}

has_valid_network_interface(resource, doc) {
  doc.resource.aws_network_interface[name]
  resource_network = split(resource.network_interface,".")[1]
  name == resource_network
}

has_nat_gateway(name, doc) {
  resource = doc.resource
  gateway_name = split(resource.aws_nat_gateway[_].allocation_id,".")[1]
  gateway_name == name
}

has_transfer_server(name,doc) {
  resource = doc.resource
  server_name = split(resource.aws_transfer_server[_].endpoint_details.address_allocation_ids[_],".")[1]
  server_name == name
}

get_allowed_types(instance) = result {
  contains(instance, "aws_instance")
  result := "aws_instance"
} else = result {
  contains(instance, "aws_network_interface")
  result := "aws_network_interface"
} else = result {
  result := "none"
}

resource_exists(resource_name, resource_type, document) {
	common_lib.valid_key(document.resource[resource_type], resource_name)
}
