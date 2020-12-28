package Cx

CxPolicy [result] {
  playbooks := input.document[i].playbooks
  sql_instance := playbooks[j]
  instance := sql_instance["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  ip_configuration := settings.ip_configuration
  
  count(ip_configuration.authorized_networks) > 0 
  authorized_network = ip_configuration.authorized_networks[id]
  authorized_network.value == "0.0.0.0"
  network := authorized_network.name

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value", [playbooks[j].name,network]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value address is trusted", [playbooks[j].name,network]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value address is not restricted: '0.0.0.0'", [playbooks[j].name,network])
              }
}

CxPolicy [result] {
  playbooks := input.document[i].playbooks
  sql_instance := playbooks[j]["google.cloud.gcp_sql_instance"]
  settings := sql_instance.settings
  ip_configuration := settings.ip_configuration

  object.get(ip_configuration,"authorized_networks","undefined") == "undefined"
  isTrue(ip_configuration.ipv4_enabled)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue":  sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled is disabled when there are no authorized networks", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled is enabled when there are no authorized networks", [playbooks[j].name])
              }
}

CxPolicy [ result ] {
  playbooks := input.document[i].playbooks
  sql_instance := playbooks[j]["google.cloud.gcp_sql_instance"]
  settings := sql_instance.settings

  object.get(settings,"ip_configuration","undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings", [playbooks[j].name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration is defined and allow only trusted networks", [playbooks[j].name]),
                "keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration is undefined", [playbooks[j].name])
              }
}

isTrue(attribute) {
  attribute == "yes"
} else {
  attribute == true
} else = false