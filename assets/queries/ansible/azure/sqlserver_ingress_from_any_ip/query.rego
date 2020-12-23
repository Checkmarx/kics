package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  fwRule := task["azure.azcollection.azure_rm_sqlfirewallrule"]
  fwRuleName := task.name
  
  fwRule.start_ip_address == "0.0.0.0"
  isUnsafeEndIpAddress(fwRule.end_ip_address)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure.azcollection.azure_rm_sqlfirewallrule}}.end_ip_address", [fwRuleName]),
                "issueType":        "WrongValue",
                "keyExpectedValue": "azure.azcollection.azure_rm_sqlfirewallrule should not allow all IPs (range from start_ip_address to end_ip_address)",
                "keyActualValue":   "azure.azcollection.azure_rm_sqlfirewallrule should allows all IPs"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isUnsafeEndIpAddress("0.0.0.0")
isUnsafeEndIpAddress("255.255.255.255")
