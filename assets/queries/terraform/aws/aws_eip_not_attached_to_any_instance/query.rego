package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib


CxPolicy[result] {
  # Unattached - valid vpc but no association of any kind
	EIP := input.document[i].resource.aws_eip[eip_name]
    
  bool_has_valid_vpc(EIP) 
  not has_valid_instance(EIP,input.document[i])
  not has_eip_associated(eip_name, input.document[i])
  not has_valid_network_interface(EIP, input.document[i])
  not has_nat_gateway(eip_name, input.document[i])
  not has_transfer_server(eip_name, input.document[i])
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eip",
		"resourceName": tf_lib.get_resource_name(EIP, eip_name),
		"searchKey": sprintf("aws_eip[%s]", [eip_name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_eip", eip_name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "All EIPs should be attached",
		"keyActualValue": "EIP is not attached"
	}
}

CxPolicy[result] {
  # Unattached - invalid vpc with dynamic "ActualValue"
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

has_valid_instance(resource,doc) {
    # Instance must exist in the file
    common_lib.valid_key(resource,"instance")
    instance_name = split(resource.instance,".")[1]
    instance_type = get_allowed_types(split(resource.instance,".")[0])

    resource_exists(instance_name,instance_type,doc)
}

has_eip_associated(eip_name, doc) {
  # "allocate" field should be defined as the eip and "instance" associated must exist in the document
  association := doc.resource.aws_eip_association[_]
  allocated_eip = split(association.allocation_id,".")[1]
  eip_name == allocated_eip

  instance_id := association.instance_id
  instance_type = get_allowed_types(split(instance_id,".")[0])
  instance_type != "none"
  instance_name = split(instance_id,".")[1]

  resource_exists(instance_name,instance_type,doc)
}

has_valid_network_interface(resource, doc) {
  # Resource´s network interface must exist in the document
  resource_interface := split(resource.network_interface,".")[1]
  doc.resource.aws_network_interface[valid_interface]
  resource_interface == valid_interface
}

has_nat_gateway(eip_name, doc) {
  # nat_gateway must include eip
  eips_in_nat_gateway := split(doc.resource.aws_nat_gateway[_].allocation_id,".")[1]
  eip_name == eips_in_nat_gateway
}

has_transfer_server(eip_name,doc) {
  # transfer_server must include eip
  eip_in_transfer_server := split(doc.resource.aws_transfer_server[_].endpoint_details.address_allocation_ids[_],".")[1]
  eip_name == eip_in_transfer_server
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
