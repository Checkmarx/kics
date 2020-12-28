package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  appGateway := task["azure_rm_appgateway"]
  tier := appGateway.sku.tier

  not startswith(tier,"waf")

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_appgateway}}.sku.tier", [task.name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_appgateway.sku.tier should be 'waf' or 'waf_v2'",
                "keyActualValue":   sprintf("azure_rm_appgateway.sku.tier is %s",[tier])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}