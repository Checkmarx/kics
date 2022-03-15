package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	ram_users := [ram_users | docs := input.document; docs[i].resource.alicloud_ram_user[name]; ram_users := {"id": docs[i].id, "name": name}]
	count(ram_users) > 0
    ram_user := ram_users[0]
    not has_preference(input.document) 
	#resource alicloud_ram_user
	result := {
    	"documentId": ram_user.id,
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
		"searchKey": sprintf("alicloud_ram_security_preference[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enforce_mfa_for_login' should be defined and set to true",
		"keyActualValue": "'enforce_mfa_for_login' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_security_preference", name], []),
	}
}

CxPolicy[result] {
	has_ram_user(input.document)
	resource := input.document[id].resource.alicloud_ram_security_preference[name]
    resource.enforce_mfa_for_login == false
	result := {
    	"documentId": input.document[id].id,
		"searchKey": sprintf("alicloud_ram_security_preference[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enforce_mfa_for_login' should be set to true",
		"keyActualValue": "'enforce_mfa_for_login' is set to 'false'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_security_preference", name, "enforce_mfa_for_login" ], []),
	}
}
