package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	ram_users := [ram_users | docs := input.document; resource := docs[i].resource.alicloud_ram_user[name]; ram_users := {"id": docs[i].id, "name": name, "resource": resource}]
	count(ram_users) > 0
    ram_user := ram_users[0]
    not has_preference(input.document) 

	result := {
    	"documentId": ram_user.id,
		"resourceType": "alicloud_ram_user",
		"resourceName": ram_user.name,
		"resourceName": tf_lib.get_resource_name(ram_user.resource, ram_user.name),
		"searchKey": sprintf("alicloud_ram_user[%s]", [ram_user.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "alicloud_ram_security_preference resource should be defined",
		"keyActualValue": "alicloud_ram_security_preference resource is not defined",        
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_user", ram_user.name], []),
	}
}

has_preference(doc){
	doc[_].resource["alicloud_ram_security_preference"]
}

has_ram_user(doc){
	doc[_].resource["alicloud_ram_user"]
}

CxPolicy[result] {
	has_ram_user(input.document)
	resource := input.document[id].resource.alicloud_ram_security_preference[name]
    not common_lib.valid_key(resource,"enforce_mfa_for_login")

	result := {
    	"documentId": input.document[id].id,
		"resourceType": "alicloud_ram_security_preference",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_security_preference[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enforce_mfa_for_login' should be defined and set to true",
		"keyActualValue": "'enforce_mfa_for_login' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_security_preference", name], []),
		"remediation": "enforce_mfa_for_login = true",
		"remediationType": "addition",	
	}
}

CxPolicy[result] {
	has_ram_user(input.document)
	resource := input.document[id].resource.alicloud_ram_security_preference[name]
    resource.enforce_mfa_for_login == false
	
	result := {
    	"documentId": input.document[id].id,
		"resourceType": "alicloud_ram_security_preference",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_security_preference[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enforce_mfa_for_login' should be set to true",
		"keyActualValue": "'enforce_mfa_for_login' is set to 'false'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_security_preference", name, "enforce_mfa_for_login" ], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",	
	}
}
