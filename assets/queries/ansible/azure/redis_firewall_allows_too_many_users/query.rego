package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  redis_cache := playbooks[j]
  instance := redis_cache["azure_rm_rediscachefirewallrule"]
  occupied_hosts := getHosts(instance.start_ip_address)
  all_hosts := getHosts(instance.end_ip_address)
  available := abs(all_hosts-occupied_hosts)

  available > 255

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address and end_ip_address allows up to 255 hosts", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address and end_ip_address allow %s", [playbooks[j].name,available])
              }
}

getHosts(ip) = nhosts {
  nums := split(ip,".")
  # ip = x.y.z.w
  # hosts = x * 2^24 + y * 2^16 + z * 2^8 + w 
  # 2^24 = 16777216  2^16 = 65536  2^8 = 256
  nhosts := (to_number(nums[0]) * 16777216) + (to_number(nums[1]) * 65536) + (to_number(nums[2]) * 256) + to_number(nums[3])
} 

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}